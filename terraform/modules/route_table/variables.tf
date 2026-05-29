variable "project_name" {
  type        = string
  description = "Name of the project."

  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "project_name cannot be empty."
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment."

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC."

  validation {
    condition     = startswith(var.vpc_id, "vpc-")
    error_message = "vpc_id must start with 'vpc-'."
  }
}

variable "internet_gateway_id" {
  type        = string
  description = "ID of the Internet Gateway."

  validation {
    condition     = startswith(var.internet_gateway_id, "igw-")
    error_message = "internet_gateway_id must start with 'igw-'."
  }
}

variable "nat_gateway_id" {
  type        = string
  description = "ID of the NAT Gateway."

  validation {
    condition     = startswith(var.nat_gateway_id, "nat-")
    error_message = "nat_gateway_id must start with 'nat-'."
  }
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs."

  validation {
    condition = alltrue([
      for subnet_id in var.public_subnet_ids : startswith(subnet_id, "subnet-")
    ])
    error_message = "Each public subnet ID must start with 'subnet-'."
  }

  validation {
    condition     = length(var.public_subnet_ids) > 0
    error_message = "At least one public subnet ID is required."
  }
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs."

  validation {
    condition = alltrue([
      for subnet_id in var.private_subnet_ids : startswith(subnet_id, "subnet-")
    ])
    error_message = "Each private subnet ID must start with 'subnet-'."
  }

  validation {
    condition     = length(var.private_subnet_ids) > 0
    error_message = "At least one private subnet ID is required."
  }
}

variable "public_destination_cidr_block" {
  type        = string
  description = "Destination CIDR block for public internet route."
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.public_destination_cidr_block, 0))
    error_message = "public_destination_cidr_block must be a valid CIDR block."
  }
}

variable "private_destination_cidr_block" {
  type        = string
  description = "Destination CIDR block for private internet route through NAT."
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.private_destination_cidr_block, 0))
    error_message = "private_destination_cidr_block must be a valid CIDR block."
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
  default     = {}
}