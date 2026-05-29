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
  description = "ID of the VPC where subnets will be created."

  validation {
    condition     = startswith(var.vpc_id, "vpc-")
    error_message = "vpc_id must start with 'vpc-'."
  }
}

variable "subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    public            = bool
  }))

  description = "Map of subnet definitions."

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) :
      can(cidrhost(subnet.cidr_block, 0))
    ])
    error_message = "Each subnet cidr_block must be a valid CIDR block."
  }

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) :
      length(trimspace(subnet.availability_zone)) > 0
    ])
    error_message = "Each subnet availability_zone cannot be empty."
  }

  validation {
    condition     = length(var.subnets) > 0
    error_message = "At least one subnet must be defined."
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
  default     = {}
}