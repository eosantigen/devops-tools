include "root" {
  path = find_in_parent_folders()
}

include "auth_provider" {
  path = find_in_parent_folders("auth_provider.hcl")
}

include "auth_backend" {
  path = find_in_parent_folders("auth_backend.hcl")
}

include "versions" {
  path = find_in_parent_folders("versions.hcl")
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/modules//aks"
}