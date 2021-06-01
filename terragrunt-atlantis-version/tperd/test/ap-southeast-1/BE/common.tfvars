### VPCs ###
# Backend
vpc_backend_az_start = 1
vpc_backend_az_end = 3
vpc_backend_cidr = "10.120.0.0/16"
vpc_backend_pri_subnets = [
  "10.120.1.0/24",
  "10.120.10.0/24"
]
vpc_backend_pub_subnets = [
  "10.120.2.0/24",
  "10.120.20.0/24"
]
vpc_backend_reuse_nat_ips = false
// vpc_backend_nat_eip_ids = [
//   "eipalloc-???",
//   "eipalloc-???"
// ]

