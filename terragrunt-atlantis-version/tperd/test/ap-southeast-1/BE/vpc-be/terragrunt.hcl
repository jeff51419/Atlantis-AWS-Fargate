locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  project_vars     = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))


  # Extract out common variables for reuse
  env         = local.environment_vars.locals.environment
  aws_project = local.project_vars.locals.aws_project
  aws_region  = local.region_vars.locals.aws_region
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
# git@github.com:terraform-aws-modules/terraform-aws-vpc.git

terraform {
  source = "${get_terragrunt_dir()}/../../../../../../terraform/module//vpc-be"
}


# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name                    = "stp-vpc-backend"
  vpc_backend_az_start    = 1
  vpc_backend_az_end      = 3
  vpc_backend_cidr        = "10.120.0.0/16"
  vpc_backend_pri_subnets = ["10.120.1.0/24","10.120.10.0/24"]
  vpc_backend_pub_subnets = ["10.120.2.0/24","10.120.20.0/24"]
  # for allocate EIPs manually
  # ["eipalloc-xxxxxxxxxxxxxxxxx","eipalloc-xxxxxxxxxxxxxxxxx"]
  vpc_backend_reuse_nat_ips = false
  # vpc_backend_nat_eip_ids = []
  project               = "${local.aws_project}"
  environment           = "${local.env}"
  region                = "${local.aws_region}"
}
#