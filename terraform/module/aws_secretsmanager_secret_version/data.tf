data "aws_secretsmanager_secret_version" "creds" {
  secret_id = var.secret_id
}

locals {
  aws_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

