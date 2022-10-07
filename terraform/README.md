# Begin here

The Terraform documentation and the cli is a masterpiece!

Please download the executable itself (please use 1.1.5 version, as of February 2022), and not use a repository version, so that we are on the same version and to avoid danger of updates. Run echo $PATH it should include /usr/local/bin - so, move the executable there. Easy!

It is imperative and totally recommended that you use VSCode for adding the official plugin for syntax highlighting and auto-completion. (please avoid running commands through the VSCode palette, but use the shell commandline itself.) .


# Azure CLI Authentication

Any authorized user must run `az login` FIRST, IF they plan to run plan | apply . Otherwise the plan|apply functions in terraform.sh will fail. (they use authentication & authorization context)

# Configuration Items

Azure:

- resource group
- storage account
- storage account container(s)
- databricks workspace
- IAM
- virtual network

Ansible:

- send Slack notifications to the relevant channel upon any successful deployment.

# Per Client Configuration

Because we have various clients, each client's variables/values will be contained in ./clients/<client_name>.tfvars file, which will have to be passed as a mandatory parameter through the ./init/terraform.sh script.

## All begins at init/

`env.sh` : Exports various env vars and settings to be sourced in the other shell scripts.

`client_init.sh` : simply prompts for the client's name to initialize the relative variables in a separate file.

    Initialize new client: `./client_init.sh -c <client_name>`

`auth.sh` : does all Azure CLI authentication checks and is sourced by terraform.sh script as the first step.

`terraform.sh`

    Create/Update a client’s resource: `./terraform.sh -c <client_name> -d <deployment_name>`

    Create/Update a client's resource at a specific point: `./terraform.sh -c <client_name> -d <deployment_name> -t <'name.reference_name'>`

    Delete a client’s resource : `./terraform.sh -c <client_name> -d <deployment_name> [ -t <'name.reference_name'> ] -X` (TODO)

`-c` ....must match an existing ./clients/<client_name>.tfvars, or will exit (auto-check)

`-d` ....must match any configuration filename that is under deployments folder, or will exit (auto-check)

`-t` ....(optional) used in conjunction with -c & -d . Very helpful! E.g. you made a mistake in the databricks deployment but don’t want to tear down any other resource mentioned in the root module, you want the execution to refer to a very specific module inside the deployment’s root module . E.g. to modify its tags or IAM…

##  Steps

1. `./client_init.sh -c <client_name>`

2. Edit `clients/<client_name>.tf` variables accordingly. 

3. `./terraform.sh -c <client_name> -d <deployment_name> [-t <'name.reference_name'> ]`

4. If 3 is ok, a plan has been prepared. Triple-check all shown in the output is correct and then : `terraform -chdir=../azure/deployments/<deployment_name>/  apply "/tmp/plan-<client_name>-<deployment_name>"`  or if  -t is  specified: `"/tmp/plan-target-<client_name>-<deployment_name>"`

5. Take a sip of your coffee.

File Structure

This has been decided as the most efficient structure, after lots of brainstorming and lots of tests. However, any kind of refactoring is also easily done.
```
.
├── ansible
│   └── notify_slack
│       ├── plays
│       │   ├── databricks.yaml
│       │   ├── service_principal.yaml
│       │   ├── storage.yaml
│       │   └── subscription.yaml
│       └── vars.yaml
├── azure
│   ├── clients
│   │   └── unipi.tfvars
│   ├── deployments
│   │   ├── databricks
│   │   │   ├── databricks.tf
│   │   │   └── terraform.tfstate.d
│   │   │       └── unipi
│   │   │           └── terraform.tfstate
│   │   ├── datalake
│   │   │   ├── datalake.tf
│   │   │   └── terraform.tfstate.d
│   │   │       └── unipi
│   │   │           └── terraform.tfstate
│   │   ├── service_principal
│   │   │   └── service_principal.tf
│   │   └── subscription
│   │       └── subscription.tf
│   └── modules
│       ├── databricks
│       │   └── workspace
│       │       ├── main.tf
│       │       ├── outputs.tf
│       │       └── variables.tf
│       ├── global_admin_tasks
│       │   ├── service_principal
│       │   │   ├── main.tf
│       │   │   └── variables.tf
│       │   └── subscription
│       │       ├── main.tf
│       │       └── variables.tf
│       ├── resource_group
│       │   ├── main.tf
│       │   └── variables.tf
│       ├── storage
│       │   ├── main.tf
│       │   └── variables.tf
│       └── virtual_network
│           ├── main.tf
│           ├── outputs.tf
│           └── variables.tf
├── init
│   ├── ansible_install.sh
│   ├── auth.sh
│   ├── client_init.sh
│   ├── client_init.template.tfvars
│   ├── env.sh
│   └── terraform.sh
├── README.md
└── TODO.md

24 directories, 34 files
```

# Troubleshooting Guide

**Note** : All the following has been tested.

## Case: The State has been lost. How to import managed resources into the State

This is also the case when you have made changes through the Azure Portal on resources that are managed with TF. How will TF be aware of those changes? It won’t. So you need to import those changes to keep it in sync.

Terraform is very powerful in many ways. This includes keeping a State - a record with the details of the resources you have built (either with it, or even without it!). It is generally ideal to include the terraform.tfstate file into Git. If, for some reason, this record is missing when you change machines, and you need to manage them but they cannot be found, do not fear - the import command is here! :D

Example: you have a client 'unipi' with a deployment 'databricks' within some Azure Subscription with some <SUBSCRIPTION_ID> - then, just replace the full ID accordingly (can be found from the Portal->Properties) - and execute:

`terraform -chdir=../azure/deployments/databricks import -config=../../modules/resource_group -var-file=../../clients/unipi.tfvars azurerm_resource_group.resource_group /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/rg-databricks-unipi`

The above command, will import only to a reference/resourceId as this has been defined in the respective config file as azurerm_resource_group.resource_group . But it has no idea of its dependencies, or other grouped resources. So, you need to run the command multiple times for each resource with its respective reference/resourceId . During the import, and depending on the configuration, you may need to type variable values when prompted, so you may have the respective <client_name>.tfvars file open for convenience.

## Case: You want to update a specific property of a specific resource

Example: You want to only update the IAM of a previously created Resource Group of Databricks, or you want to update a property of its Subnets. Then, you shouldn't need to execute the entire related deployment.

So, in this case, you have the option of -target .

The wrapper shell script implements this, so you can use it likewise, for example:

`./terraform.sh -c <client_name> -d databricks -t 'module.resource_group'`

`./terraform.sh -c <client_name> -d databricks -t 'module.network'`

(Of course, you re-run it only after you have updated the respective values on the respective .tfvars file! Otherwise, no changes will be detected.)

**NOTE:** The wrapper shell script has -yet- no condition check whether -t has been specified at the initial step, so it will execute the plan without it first, and then it will recognize that the -t has been specified. This results in the plan being generated twice, and the first plan will throw the notice of replacement. It's ok, it is safe. You just proceed with opting Y in the following prompt - it will generate a new plan with your very specific change/update-in-place.

## Case: How to add an AppRegistration/SP to IAM

When you create a new "app registration" in the Azure portal, actually two objects are created: An application object and a service principal object. The object ID which appears in the Azure portal is the application object ID, not the service principal object ID. So what you can do is:

List details for the AR/SP,  likewise:
`az ad sp list --filter "displayName eq '<app_reg_name>"`

**Use the object ID from the CLI as the object ID you enter in Terraform.**

## Using Comments in the configuration files

If you have already applied a configuration and then comment out some parts of it in the module, and re-execute it, Terraform will assume that you want to destroy those commented out blocks because they do not exist in the configuration. Sometimes this is all you want, other times may be a problem.

# Various Advice

- Although this project seems complex, it is actually very easy!
-an empty "default" marks a variable as Optional.
- If not using the wrapper shell scripts, always run terraform validate && terraform plan before running apply ! It does hugely helpful pre-flight checks (including the authentication to Azure). It can also write the plan to a file, which can be imported to the apply command as a parameter.
- Be VERY EXPLICIT on the commandline and on the namings, please.
- As a safety mechanism, you may add sleep 4m in some points in the wrapper shell scripts in order to allow some time for double-checking what is going to be configured (before having reached the final command of 'apply'.). This way,if you spot something wrong, you can just enter ctrl^c to stop the execution.
- Generally, in deployments/ use "module" definitions. In modules/ use "resource", "data" . (very generally speaking). This allows for a top-down approach. This also means that a reversed, bottom-up approach must be assumed when you begin to write new packages.
- The .tf files inside the deployments folder, serve as the root module configuration, which calls what is under the modules/, which allows for "implicit provider inheritance" downstream the referenced modules (best-practice). This way, you specify repetitive common blocks only once, on the root module. Easy!
- the names of the files .tf are purely arbitrary and there is no convention-over-configuration for this.(with minor exceptions.)
- Initialization & Configuration Updates - Careful with updates in variables and in configuration items: Certain types of changes to a configuration file can require re-initialization before normal operations can continue. This includes changes to provider requirements, module sources or version constraints, and backend configurations. Also, some resources require to be re-created upon any update of their state - e.g you have made a change in some variable or a change anywhere in the module hence you and need to rerun a plan first . (The cli will inform you if you have stale state.) . What parameters trigger a resource re-creation (full deletion and creation from scratch) is determined by their provider (eg azurerm) and mentioned in their provider documentation. Also, note : if you comment out resource and re-initialise and re-plan, it will prepare the plan for destroy because it won't find the previously created resource definition! (but it will warn you)........ But in general the flow is quite safe by itself.
- State & Modifications without TF on TF-managed resources: It is advisable that any resource managed with TF is not modified without it. E.g. if you have a Resource Group with IAM and  need to modify its IAM, it is ideal to use your respective variables file. This is because TF will not automatically sync its state(see above) with the remote backend.
- ALthough the configuration  files are already well-tested , ALWAYS TRIPLE-CHECK THE OUTPUT OF THE PLAN will create the correct stuff. It is a life-saver and a LAW.
- You may think it's dangerous but it's not because:
    - First of all, any change that is to be made (if any)  is shown in the plan output, which you have to examine carefully first. In this plan, if something is to be destroyed, will be shown in red.
    - Secondly, in order to apply those changes shown in the plan, you must separately, in a separate step, to type a separate command, which, if some resource  is to be deleted, it will prompt you to type "yes", before it proceeds to apply .