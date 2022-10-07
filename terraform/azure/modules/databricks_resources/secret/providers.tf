terraform {
  required_version = "~>1.1"
  required_providers {
    databrickslabs = {
      source = "databrickslabs/databricks"
      version = "0.5.4"
    }
  }
}