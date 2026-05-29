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
  description = "ID of the VPC where the Internet Gateway will be attached."

  validation {
    condition     = startswith(var.vpc_id, "vpc-")
    error_message = "vpc_id must start with 'vpc-'."
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
  default     = {}
}