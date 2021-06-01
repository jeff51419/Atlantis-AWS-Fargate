# VPC - use these parameters to create new VPC resources
cidr = "10.118.0.0/16"
private_subnets = ["10.118.1.0/24", "10.118.2.0/24",  "10.118.3.0/24"]
public_subnets = ["10.118.11.0/24", "10.118.12.0/24", "10.118.13.0/24"]
// azs = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]

// region = "ap-southeast-1"
route53_zone_name = "example.com"
// office ip
alb_ingress_cidr_blocks = ["1.2.3.4/32", ]

# ACM (SSL certificate)
# Specify ARN of an existing certificate or new one will be created and validated using Route53 DNS:
certificate_arn = "arn:aws:acm:ap-southeast-1:1111111111:certificate/aaaaaa-bbbb-cccc-dddd-aa2c981335fa"

# ECS Service and Task
ecs_service_assign_public_ip = true

atlantis_repo_allowlist = ["github.com/jeff51419/*"]
atlantis_image = "jeff51419/atlantis-terragrunt:v1.3.0"
atlantis_github_user = "jeff51419"
atlantis_allowed_repo_names = ["terragrunt-repo"]
trusted_principals = ["ssm.amazonaws.com"] # Convenient if you want to enable SSM access into Atlantis for troubleshooting etc
