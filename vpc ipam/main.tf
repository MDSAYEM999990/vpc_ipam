provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  name = "${var.project}-${var.environment}-vpc"

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "Minibajar-Team"
  }
}

################################################################################
# IPAM Setup
################################################################################

# IPAM root
resource "aws_vpc_ipam" "this" {
  operating_regions {
    region_name = var.region
  }
  tags = local.tags
}

# IPv4 Pool
resource "aws_vpc_ipam_pool" "ipv4" {
  description                       = "Prod IPv4 Pool"
  address_family                    = "ipv4"
  ipam_scope_id                     = aws_vpc_ipam.this.private_default_scope_id
  locale                            = var.region
  allocation_default_netmask_length = 16
  tags                              = local.tags
}

resource "aws_vpc_ipam_pool_cidr" "ipv4" {
  ipam_pool_id = aws_vpc_ipam_pool.ipv4.id
  cidr         = var.ipam_ipv4_cidr
}

# IPv6 Pool
resource "aws_vpc_ipam_pool" "ipv6" {
  description                       = "Prod IPv6 Pool"
  address_family                    = "ipv6"
  ipam_scope_id                     = aws_vpc_ipam.this.public_default_scope_id
  locale                            = var.region
  allocation_default_netmask_length = 56
  publicly_advertisable             = false
  aws_service                       = "ec2"
  tags                              = local.tags
}

# IPv6 CIDR authorization
resource "aws_vpc_ipam_pool_cidr" "ipv6" {
  ipam_pool_id = aws_vpc_ipam_pool.ipv6.id
  cidr         = var.ipam_ipv6_cidr

  cidr_authorization_context {
    message   = var.ipv6_auth_message
    signature = var.ipv6_auth_signature
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  # Dual Stack
  use_ipam_pool     = true
  ipv4_ipam_pool_id = aws_vpc_ipam_pool.ipv4.id
  ipv6_ipam_pool_id = aws_vpc_ipam_pool.ipv6.id
  cidr              = var.vpc_ipv4_cidr


  private_subnets  = var.private_subnets_ipv4
  public_subnets   = var.public_subnets_ipv4
  database_subnets = var.database_subnets_ipv4

  # Dual stack enable
  enable_ipv6 = true

  public_subnet_ipv6_prefixes   = [0, 1, 2]
  private_subnet_ipv6_prefixes  = [3, 4, 5]
  database_subnet_ipv6_prefixes = [6, 7, 8]

  enable_dns_support   = true
  enable_dns_hostnames = true

  # NAT (IPv4 only)
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true


  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    Tier                     = "public"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    Tier                              = "private"
  }

  database_subnet_tags = {
    Tier = "database"
  }

  tags = local.tags
}


################################################################################
# VPC Endpoints (S3, DynamoDB)
################################################################################

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.0"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.vpc.default_security_group_id]

  endpoints = {
    s3 = {
      service = "s3"
    }
    dynamodb = {
      service = "dynamodb"
    }
  }

  tags = local.tags
}