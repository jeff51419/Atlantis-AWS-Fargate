output "aws_creds_access_key" {
  description = "access_key"
  value       = local.aws_creds.access_key
  sensitive = true
}

output "aws_creds_secret_key" {
  description = "secret_key"
  value       = local.aws_creds.secret_key
  sensitive = true
}

output "github_user_token" {
  description = "github_user_token"
  value       = local.aws_creds.github_user_token
  sensitive = true
}