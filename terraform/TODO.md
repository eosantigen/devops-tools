# TODO - ASAP

- Fix the `terraform_plan_to_destroy()` function. It will be in a safe environment and won't even touch the existing resources. Already partly tested.
```
( -X ....(optional - use with caution) used in conjunction with -c & -d & [ -t ]. Activates the destroy option in `terraform plan` and `apply` commands and executes them, ONLY AFTER it has received "YES-DESTROY" when prompted for confirmation with the message `CAUTION! This will DESTROY the specified resource [databricks] for client/environment [unipi]! Are you ABSOLUTELY sure?” YES-DESTROY/N [default: N]` with a pause of 4 minutes before executing 'apply' . _(άλλες δικλείδες ασφαλείας γίνεται?)_ )
```
- Refactor the Databricks option for NAT GW with bool check _(can be tested in the next workspace)_
- Fix the check in terraform.sh script to initialize the workspace too.
- [HOT] Multiple Databricks Workspaces case. Refactor for iteration. - _(can be tested in  the next workspace)_
- [HOT] Create workspace with adb-<client_name>-admin  - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret


# TODO - LATER

- Arrange for Jenkins
- Create the resources with client SP (either through Jenkins or from PC.)
