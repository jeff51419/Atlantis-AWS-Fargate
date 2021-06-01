# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name      = "account-1"
  aws_account_name  = "aws-account-1"
  aws_profile       = "profile-1"
  aws_assume_role   = "arn:aws:iam::111111111:role/aws_assume_role"
}