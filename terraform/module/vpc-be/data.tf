# data "aws_route53_zone" "deploy_zone" {
#   name = var.domain
# }

data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_caller_identity" "current" {}

data "aws_subnet_ids" "stp-vpc-backend-private" {
  vpc_id = module.vpc-be.vpc_id

  filter {
    name = "tag:Name"
    values = [
      "stp-vpc-backend-private-${var.region}*"
    ]
  }

  depends_on = [module.vpc-be]
}

