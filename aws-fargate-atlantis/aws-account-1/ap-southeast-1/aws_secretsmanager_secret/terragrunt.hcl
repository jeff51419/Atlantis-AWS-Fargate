locals {
  # Automatically load environment-level variables
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))


  # Extract out common variables for reuse
  aws_region  = local.region_vars.locals.aws_region
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
# git@github.com:terraform-aws-modules/terraform-aws-vpc.git

terraform {
  source = "${get_terragrunt_dir()}/../../../../terraform/module//aws_secretsmanager_secret_version"
}


# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  # Specifies the secret containing the version that you want to retrieve. 
  # You can specify either the Amazon Resource Name (ARN) or the friendly name of the secret.
  secret_id = "secretsmanager-name"
}