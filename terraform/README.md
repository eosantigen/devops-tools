# Begin here

[Terraform Registry - AzureRM](https://www.terraform.io/)

The Terraform documentation and the cli is a masterpiece!

Please download the executable itself (please use 1.1.5 version, as of February 2022), and not use a repository version, so that we are on the same version and to avoid danger of updates. Run echo $PATH it should include /usr/local/bin - so, you can move the executable there. Easy!

It is imperative and totally recommended that you use VSCode for adding the official plugin for syntax highlighting and auto-completion. (Note: please avoid running commands through the VSCode UI, but use the instructions below.) .

All code resides in the repository devops-tools  . It does not include the TF State, which is pushed in a Blob Storage container . The clients folder is encrypted onto the repo with git-secret .

# File Structure

This has been decided as the most efficient structure, after lots of brainstorming and lots of tests. However, any kind of refactoring is also easily done.
```
./terraform
── ansible
│   └── notify_slack
│       ├── plays
│       │   ├── databricks_cluster_pool.yaml
│       │   ├── databricks_cluster.yaml
│       │   ├── databricks_dbfs_mount.yaml
│       │   ├── databricks_workspace.yaml
│       │   ├── datatabricks_sql_endpoint.yaml
│       │   └── storage.yaml
│       └── vars.yaml
├── azure
│   ├── deployments
│   │   ├── databricks
│   │   │   └── databricks.tf
│   │   ├── databricks_cluster_pool
│   │   │   └── databricks_cluster_pool.tf
│   │   ├── databricks_secret
│   │   │   └── databricks_secret.tf
│   │   ├── databricks_secret_scope
│   │   │   └── databricks_secret_scope.tf
│   │   └── datalake
│   │       └── datalake.tf
│   ├── env_tfbackend.sh
│   └── modules
│       ├── databricks
│       │   ├── network
│       │   │   ├── main.tf
│       │   │   ├── outputs.tf
│       │   │   └── variables.tf
│       │   └── workspace
│       │       ├── main.tf
│       │       ├── outputs.tf
│       │       └── variables.tf
│       ├── databricks_resources
│       │   ├── cluster
│       │   │   ├── main.tf
│       │   │   └── variables.tf
│       │   ├── cluster_pool
│       │   │   ├── main.tf
│       │   │   └── variables.tf
│       │   ├── secret
│       │   │   ├── main.tf
│       │   │   ├── providers.tf
│       │   │   └── variables.tf
│       │   ├── secret_scope
│       │   │   ├── main.tf
│       │   │   ├── providers.tf
│       │   │   └── variables.tf
│       │   └── sql_endpoint
│       ├── resource_group
│       │   ├── main.tf
│       │   └── variables.tf
│       └── storage
│           ├── main.tf
│           └── variables.tf
├── init
│   ├── ansible_install.sh
│   ├── auth.sh
│   ├── client_init.sh
│   ├── client_init.template.tfvars
│   ├── env.sh
│   └── terraform.sh
├── README.md
└── TODO.md

23 directories, 41 files
```

# Configuration Items

## Azure

1. resource group

2. storage account

3. storage account container(s)

4. databricks workspace

5. databricks resources

6. IAM on each of the above

## Ansible

1. send Slack notifications to the relevant channel upon any successful deployment.

# Azure CLI Authentication

    This is DEPRECATED/UNUSED but may be eligible for use again in the future:

Any authorized user must run az login FIRST, IF they plan to run plan | apply . Otherwise the plan|apply functions in terraform.sh will fail. (they use authentication & authorization context)

# Per Client Configuration - Wrapper shell scripts

Some Bash shell wrapper scripts have been implemented as a custom solution to manage different states and environments (also called “workspaces”), as well as attain to a more easy and secure to implement, execute & manage solution. This is because these scripts only prepare the plan based on targeted resources named as “deployments”, and do not execute the final apply command automatically.

Each client's variables are automatically instantiated and manually populated in `./clients/<client_name>.tfvars` with the use of placeholder CLIENT_NAME and the Bash command sed .

# All begins at directory init/

**env.sh** : Exports various env vars and settings to be sourced in the other shell scripts.

**client_init.sh** : simply prompts for the client's name to initialize the relative variables under clients/CLIENT_NAME.tfvars

Initialize new client: `./client_init.sh -c <client_name>`

**auth.sh** : does all Azure CLI auth checks and is sourced by terraform.sh script as the first step. (Currently not in use, because we stopped authenticating via the Azure CLI as AAD User.)

**terraform.sh**

Create/Update a client’s resource: `./terraform.sh -c <client_name> -d <deployment_name>`

Create/Update a client's resource at a specific point: `./terraform.sh -c <client_name> -d <deployment_name> -t <'name.reference_name'>`

Delete a client’s resource : `./terraform.sh -c <client_name> -d <deployment_name> [ -t <'name.reference_name'> ] -X`

**-c** ....must match an existing ./clients/<client_name>.tfvars, or will exit (auto-check)

**-d** ....must match any configuration filename that is under deployments folder, or will exit (auto-check)

**-t** ....(optional) used in conjunction with -c -d . Very helpful! E.g. you made a mistake in a deployment but don't want to tear down any other resource mentioned in the root module, you want the execution to refer to a very specific module inside the deployment's root module . E.g. to modify its tags or IAM...

**-X** …a flag to prepare the plan to delete resources. Used in conjunction with -c -d . 

# Steps

1. `./client_init.sh -c <client_name>`

2. Edit clients/<client_name>.tfvars variables accordingly. 

    - Find values for the <client_name>.tfvars and add them accordingly:

    - Find an available net range for the new Databricks workspace, and add it to the <client_name>.tfvars file in the respective field. (there are two network ranges, so two entries in a list [] . )

        - Get adb-<client_name>-admin ObjectID of the Service Principal object : az ad sp list --filter "displayName eq 'adb-<client_name>-admin'"  and add it to the respective field as IAM Contributor. (necessary to be used to configure SCIM later.)
        
        - Get ObjectID of user group rg-<client_name>-users and add it to the respective field as IAM Reader.

        - In the AUTH/ARM_ section, pass the relevant client authentication values of the App Registration for TF to authenticate on Azure.

3. Depending on the deployment you want, create the new workspace (an isolated state space for each client). `terraform -chdir=../azure/deployments/<deployment_name> workspace new <client_name>`

4. `./terraform.sh -c <client_name> -d <deployment_name> [-t <'name.reference_name'> ]`

If step 3 is ok, a plan has been prepared. Take all the time you need to triple-check and then check 10 times all shown in the output is correct and then : `terraform -chdir=../azure/deployments/<deployment_name>/  apply "/tmp/plan-<client_name>-<deployment_name>"`  or if  -t is  specified: `“/tmp/plan-target-<client_name>-<deployment_name>"`

5. Take a breath and a sip of your coffee...

# Apply / Destroy cheat sheet

Example flow for creating a Databricks Workspace, a datalake storage connected to it, and the relevant client secrets:

(assuming you have already prepared `./client_init.sh -c <CLIENT_NAME>` with the relevant contents as mentioned above..)

**Create a Databricks PaS instance**
```
terraform -chdir=../azure/deployments/databricks workspace new CLIENT_NAME

./terraform.sh -c CLIENT_NAME -d databricks

terraform -chdir=../azure/deployments/databricks/  apply "/tmp/plan-CLIENT_NAME-databricks"
```

**Create the Databricks instance Secret Scopes**
```
terraform -chdir=../azure/deployments/databricks_secret_scope workspace new CLIENT_NAME

./terraform.sh -c CLIENT_NAME -d databricks_secret_scope

terraform -chdir=../azure/deployments/databricks_secret_scope/  apply "/tmp/plan-CLIENT_NAME-databricks_secret_scope"
```

**Create the Databricks instance Secrets within the Scopes**
```
terraform -chdir=../azure/deployments/databricks_secret workspace new CLIENT_NAME

./terraform.sh -c CLIENT_NAME -d databricks_secret

terraform -chdir=../azure/deployments/databricks_secret/  apply "/tmp/plan-CLIENT_NAME-databricks_secret"
```

**Create a Datalake Storage Account connected to the Databricks instance**
```
terraform -chdir=../azure/deployments/datalake workspace new CLIENT_NAME

./terraform.sh -c CLIENT_NAME -d datalake

terraform -chdir=../azure/deployments/datalake/  apply "/tmp/plan-CLIENT_NAME-datalake"
```


# How to destroy resources

1. **First make sure you are in the CORRECT WORKSPACE with the CORRECT DEPLOYMENT** : 

`terraform -chdir=../azure/deployments/<deployment_name> workspace select <client_name>`

Also, it’s not a bad idea to inspect the current state of this workspace (=> metis-develop) for this deployment type (=> databricks_secret):

`terraform -chdir=../azure/deployments/<deployment_name> workspace show`

2. Prepare the plan for **destruction**:

`./terraform.sh -c <client_name> -d <deployment_name> -X`

3. Execute the **destruction plan**

`terraform -chdir=../azure/deployments/<deployment_name> apply "/tmp/plan-destroy-<client_name>-<deployment_name>"`

## Alternative way to destroy a resource

Simply comment out or delete a resource specification in the <client_name>.tfvars and run again the last two commands as above, without the -X option.

### Examples

To remove a secret from a Databricks workspace, or all secrets all-together:

Put the secret map key-value pair in comments likewise - careful not to remove the entire “secrets” block:

```
  secrets = {
  # develop-pg-pass = {
  #   scope = "devteam"
  #   value = "ReaderPassword"
  # }
  }
```
Then, run `./terraform.sh -c metis-develop -d databricks_secret`

It should output a plan that includes something like this:

```
module.secret.databricks_secret.secret["develop-pg-pass"] will be destroyed
(because key ["develop-pg-pass"] is not in for_each map)
resource "databricks_secret" "secret" {
    id                     = "devteam|||develop-pg-pass" -> null
    key                    = "develop-pg-pass" -> null
    last_updated_timestamp = 1649428441509 -> null
    scope                  = "devteam" -> null
    string_value           = (sensitive value)
}
```

Finally, if you are ok with it, execute the plan, again as above:

`terraform -chdir=../azure/deployments/databricks_secret/  apply "/tmp/plan-metis-develop-databricks_secret"`

# Troubleshooting Guide

Note : All the following has been tested.

## Case: The State has been lost. How to import managed resources into the State

This is also the case when you have made changes through the Azure Portal on resources that are managed with TF. How will TF be aware of those changes? It won’t. So you need to import those changes to keep it in sync.

Terraform is very powerful in many ways. This includes keeping a State - a record with the details of the resources you have built (either with it, or even without it!). It is generally ideal to include the terraform.tfstate file into Git. If, for some reason, this record is missing when you change machines, and you need to manage them but they cannot be found, do not fear - the import command is here! :D

Example: you have a client 'client-env-A' with a deployment 'databricks' within some Azure Subscription with some <SUBSCRIPTION_ID> - then, just replace the full ID accordingly (can be found from the Portal->Properties) - and execute:

`terraform -chdir=../azure/deployments/databricks import -config=../../modules/resource_group -var-file=../../clients/client-env-A.tfvars azurerm_resource_group.resource_group /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/rg-databricks-client-env-A`

The above command, will import only to a reference/resourceId as this has been defined in the respective config file as azurerm_resource_group.resource_group . But it has no idea of its dependencies, or other grouped resources. So, you need to run the command multiple times for each resource with its respective reference/resourceId . During the import, and depending on the configuration, you may need to type variable values when prompted, so you may have the respective <client_name>.tfvars file open for convenience.

## Case: You want to update a specific property of a specific resource

Example: You want to only update the IAM of a previously created Resource Group of Databricks, or you want to update a property of its Subnets. Then, you shouldn't need to execute the entire related deployment.

So, in this case, you have the option of -target .

The wrapper shell script implements this, so you can use it likewise, for example:

```
./terraform.sh -c <client_name> -d databricks -t 'module.resource_group' 

./terraform.sh -c <client_name> -d databricks -t 'module.network'
```

(Of course, you re-run it only after you have updated the respective values on the respective .tfvars file! Otherwise, no changes will be detected.)

NOTE: The wrapper shell script has -yet- no condition check whether -t has been specified at the initial step, so it will execute the plan without it first, and then it will recognize that the -t has been specified. This results in the plan being generated twice, and the first plan will throw the notice of replacement. It's ok, it is safe. You just proceed with opting Y in the following prompt - it will generate a new plan with your very specific change/update-in-place.

## Case: How to add an AppRegistration/SP to IAM

When you create a new "app registration" in the Azure portal, actually two objects are created: An application object and a service principal object. The object ID which appears in the Azure portal is the application object ID, not the service principal object ID. So what you can do is:

List details for the AR/SP,  likewise:
`az ad sp list --filter "displayName eq '<app_reg_name>"`

Use the object ID from the CLI as the object ID you enter in Terraform.

# Using Comments in the configuration files

If you have already applied a configuration and then comment out some parts of it in the module, and re-execute it, Terraform will assume that you want to destroy those commented out blocks because they do not exist in the configuration. Sometimes this is all you want, other times may be a problem.

# Encrypt/Decrypt clients folder

```
git secret reveal -p your_gpg_certificate_password
git secret hide -vd
```

# Various Advice

1. Although this project seems complex, it is actually very easy! Other than some caution details, even Koutsi Maria can execute - and even extend - it!  

2. an empty "default" marks a variable as Optional.

3. If not using the wrapper shell scripts, always run terraform validate && terraform plan before running apply ! It does hugely helpful pre-flight checks (including the authentication to Azure). It can also write the plan to a file, which can be imported to the apply command as a parameter.

4. Be VERY EXPLICIT on the commandline and on the namings, please.

5. As a safety mechanism, you may add sleep 4m in some points in the wrapper shell scripts in order to allow some time for double-checking what is going to be configured (before having reached the final command of 'apply'.). This way,if you spot something wrong, you can just enter ctrl^c to stop the execution.

6. Generally, in deployments/ use "module" definitions. In modules/ use "resource", "data" . (very generally speaking). This allows for a top-down approach. This also means that a reversed, bottom-up approach must be assumed when you begin  to write new packages.

7. The .tf files inside the deployments folder, serve as the root module configuration, which calls what is under the modules/, which allows for "implicit provider inheritance" downstream the referenced modules (best-practice). This way, you specify repetitive common blocks only once, on the root module. Easy!

8. the names of the files .tf are purely arbitrary and there is no convention-over-configuration for this.(with minor exceptions.)

9. Initialization & Configuration Updates - Careful with updates in variables and in configuration items: Certain types of changes to a configuration file can require re-initialization before normal operations can continue. This includes changes to provider requirements, module sources or version constraints, and backend configurations. Also, some resources require to be re-created upon any update of their state - e.g you have made a change in some variable or a change anywhere in the module hence you and need to rerun a plan first . (The cli will inform you if you have stale state.) . What parameters trigger a resource re-creation (full deletion and creation from scratch) is determined by their provider (eg azurerm) and mentioned in their provider documentation. Also, note : if you comment out resource and re-initialise and re-plan, it will prepare the plan for destroy because it won't find the previously created resource definition! (but it will warn you)........ But in general the flow is quite safe by itself.

10. State & Modifications without TF on TF-managed resources: It is advisable that any resource managed with TF is not modified without it. E.g. if you have a Resource Group with IAM and  need to modify its IAM, it is ideal to use your respective variables file. This is because TF will not automatically sync its state(see above) with the remote backend.

11. ALthough the configuration  files are already well-tested , ALWAYS TRIPLE-CHECK & CHECK 10 TIMES THE OUTPUT OF THE PLAN will create the correct stuff. It is a life-saver and a LAW  

12. You may think it's dangerous but it's not because:

    - First of all, any change that is to be made (if any)  is shown in the plan output, which you have to examine carefully first. In this plan, if something is to be destroyed, will be shown in red.

    - Secondly, in order to apply those changes shown in the plan, you must separately, in a separate step, to type a separate command, which, if some resource is to be deleted, it will prompt you to type "YES-DESTROY", before it proceeds to the execution .

# Cloning the repo “devops-tools”

If you are about to clone the repo and run it for the first time (or each time), it is crucial to first check the files `init/env.sh` and `azure/env_tfbackend.sh` .
In an opinionated fashion, favouring Convention over Confiugaration, the env.sh contains full paths which may not be applicable to your system, so either clone the repo under $HOME/devops-tools (default BASE_PATH), or, modify the env accordingly with your preferred paths. Ideally you would rather select the 1st option, to avoid wasting your colleagues' time with modifications of the paths...

# Using the backend: azurerm with Blob Container Storage Account

The TF State for each deployment (“root module”) is accessed in a relatively safe storage backend on Azure in the Development subscription. That is because, among other configuration properties, it contains sensitive values which are stored by Terraform itself in plain text.

Under each deployment folder,  there is a .terraform folder. It is crucial that this entire folder, and especially inside it, the terraform.tfstate must **(a) not be committed to the Git repo, because it contains the credentials of authenticating to the Azure Storage backend, (b) not be modified**. However, it is safe to be removed (not just truncated) before any new execution, but it doesn't have to because the fields are basically static/constants. 

If it gets modified, the following error will be thrown:
```
Initializing the backend...
╷
│ Error: Backend configuration changed
│ 
│ A change in the backend configuration has been detected, which may require migrating existing state.
│ 
│ If you wish to attempt automatic migration of the state, use "terraform init -migrate-state".
│ If you wish to store the current configuration with no changes to the state, use "terraform init -reconfigure".
```

To mitigate this, do not attempt any of the above, but, simply delete this file and try again....
Then, if an error, e.g. "Workspace "client-env-X" doesn't exist" , create the workspace and try again..

This terraform.tftstate file is the configuration state/static properties of the backend itself for each root module (as the deployments folder contains only root modules), which is stored in the same fashion as any other state.

The entire mechanism has been well tested for the frequent case of switching workspaces and adding/updating resources, which updates the respective state each time.