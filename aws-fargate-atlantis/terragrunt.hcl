# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load account-level variables
  account_vars      = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract the variables we need for easy access
  aws_region      = local.region_vars.locals.aws_region
  short_region    = local.region_vars.locals.short_region
  account_name    = local.account_vars.locals.account_name
  aws_profile     = local.account_vars.locals.aws_profile
  aws_assume_role = local.account_vars.locals.aws_assume_role
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"

  # Only these AWS Account IDs may be operated on by this template
  profile                 = "${local.aws_profile}"
  region                  = "${local.aws_region}"
  assume_role {
    role_arn = "${local.aws_assume_role}"
  }
}
provider "random" {
}
EOF
}
# Configure root level variables that all resources can inherit
terraform {
  extra_arguments "common_vars" {
    commands = [
      "init",
      "apply",
      "plan",
      "import",
      "push",
      "refresh"
    ]

    arguments = [
      "-var-file=${get_terragrunt_dir()}/../common.tfvars"
    ]
  }
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.account_name}-${local.short_region}-atlantis-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    profile        = local.aws_profile
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "version" {
  path = "version.tf"
  if_exists = "overwrite"
  contents = <<EOT
terraform {
  required_version = ">= 0.13.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version   = "~> 3.39.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.9.4"
    }  
  }
}
EOT
}
