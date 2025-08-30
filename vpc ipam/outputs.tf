output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets_ipv4" {
  value = module.vpc.private_subnets
}

output "public_subnets_ipv4" {
  value = module.vpc.public_subnets
}

output "database_subnets_ipv4" {
  value = module.vpc.database_subnets
}

output "vpc_ipv6_cidr" {
  value = module.vpc.vpc_ipv6_cidr_block
}

output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}


output "s3_endpoint_id" {
  value = module.vpc_endpoints.endpoints["s3"].id
}

output "dynamodb_endpoint_id" {
  value = module.vpc_endpoints.endpoints["dynamodb"].id
}