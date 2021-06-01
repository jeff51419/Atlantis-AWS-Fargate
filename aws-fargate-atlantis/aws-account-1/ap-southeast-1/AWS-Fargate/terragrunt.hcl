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
  source = "${get_terragrunt_dir()}/../../../../terraform/module//atlantis"
}


# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "aws_secretsmanager_secret" {
  config_path = "../aws_secretsmanager_secret"
  
  # it corresponds to a map that will be injected in place of the actual dependency outputs 
  # if the target config hasn’t been applied yet
  mock_outputs = {
    aws_creds_access_key    = "aws_creds_access_key"
    aws_creds_secret_key    = "aws_creds_secret_key"
    github_user_token       = "github_user_token"
  }
  # restrict this behavior
  mock_outputs_allowed_terraform_commands = ["validate","plan","init"]
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  # VPC - use these parameters to create new VPC resources
  cidr                    = "10.118.0.0/16"
  private_subnets         = ["10.118.1.0/24", "10.118.2.0/24",  "10.118.3.0/24"]
  public_subnets          = ["10.118.11.0/24", "10.118.12.0/24", "10.118.13.0/24"]

  region                  = "${local.aws_region}"
  route53_zone_name       = ""
  # office ip
  alb_ingress_cidr_blocks = []

  # ACM (SSL certificate)
  # Specify ARN of an existing certificate or new one will be created and validated using Route53 DNS:
  certificate_arn         = ""

  # ECS Service and Task
  ecs_service_assign_public_ip  = true

  atlantis_repo_allowlist       = []
  atlantis_image                = "jeff51419/atlantis-terragrunt:v1.2.0"
  atlantis_github_user          = ""
  atlantis_github_user_token    = dependency.aws_secretsmanager_secret.outputs.github_user_token
  atlantis_allowed_repo_names   = [""]
  # Convenient if you want to enable SSM access into Atlantis for troubleshooting etc
  trusted_principals            = ["ssm.amazonaws.com"]
  entrypoint                    = ["docker-entrypoint.sh"]
  command                       = ["server"]
  working_directory             = "/tmp"
  custom_environment_variables  = [
    {
      name  = "AWS_ACCESS_KEY_ID"
      value = dependency.aws_secretsmanager_secret.outputs.aws_creds_access_key
    },
    {
      name  = "AWS_SECRET_ACCESS_KEY"
      value = dependency.aws_secretsmanager_secret.outputs.aws_creds_secret_key
    },
    {
      name  = "ATLANTIS_REPO_CONFIG"
      value = "/opt/repos.yaml"
    },
    {
      name  = "ATLANTIS_TERRAFORM_VERSION"
      value = "0.15.3"
    }
  ]
}