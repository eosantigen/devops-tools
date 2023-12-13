generate "versions" {
  path = "versions.tf"
  if_exists = "overwrite"
  contents = <<EOF

    terraform {
    required_version = "~>1.6.4"
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "=3.83.0"
      }
    }
  }
  EOF
}