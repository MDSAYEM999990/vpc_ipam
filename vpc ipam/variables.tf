variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment (prod/staging/dev)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

# IPAM Pools
variable "ipam_ipv4_cidr" {
  description = "Large IPv4 block for pool"
  type        = string
}

variable "ipam_ipv6_cidr" {
  description = "IPv6 CIDR block for pool"
  type        = string
}

variable "ipv6_auth_message" {
  description = "IPv6 CIDR authorization message from AWS"
  type        = string
}

variable "ipv6_auth_signature" {
  description = "IPv6 CIDR authorization signature from AWS"
  type        = string
}

# VPC CIDRs
variable "vpc_ipv4_cidr" {
  description = "VPC IPv4 CIDR"
  type        = string
}

# Subnets (IPv4)
variable "private_subnets_ipv4" {
  type = list(string)
}

variable "public_subnets_ipv4" {
  type = list(string)
}

variable "database_subnets_ipv4" {
  type = list(string)
}
