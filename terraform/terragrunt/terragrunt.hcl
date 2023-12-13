# Contains globally applied cli configs, TF settings ie the log location & level, etc.

terraform {
  extra_arguments "tf_options" {
    commands = [
      "init",
      "apply",
      "plan",
      "import",
      "push",
      "refresh"
    ]
    arguments = [
      "-var-file=${get_parent_terragrunt_dir()}/environments/common.tfvars"
    ]
    env_vars = {
      TF_LOG_PATH = "/tmp/terraform.log"
      TF_LOG = "debug"
    }
  }
}