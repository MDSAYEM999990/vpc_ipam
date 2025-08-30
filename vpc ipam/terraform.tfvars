project     = "minibajar"
environment = "prod"
region      = "us-east-1"

# IPAM Pools
ipam_ipv4_cidr = "10.0.0.0/12"
ipam_ipv6_cidr = "2600:1f18:abcd::/56" # Example, must match AWS allocation

# These two values must be requested via AWS Support when allocating IPv6 from IPAM
ipv6_auth_message   = "AuthorizationMessageFromAWS"
ipv6_auth_signature = "SignatureFromAWS"

# VPC CIDR
vpc_ipv4_cidr = "10.10.0.0/16"

# IPv4 Subnets
private_subnets_ipv4 = [
  "10.10.1.0/24",
  "10.10.2.0/24",
  "10.10.3.0/24"
]

public_subnets_ipv4 = [
  "10.10.101.0/24",
  "10.10.102.0/24",
  "10.10.103.0/24"
]

database_subnets_ipv4 = [
  "10.10.201.0/24",
  "10.10.202.0/24",
  "10.10.203.0/24"
]
