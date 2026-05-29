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

variable "public_subnet_id" {
  type        = string
  description = "ID of the public subnet where the NAT Gateway will be created."

  validation {
    condition     = startswith(var.public_subnet_id, "subnet-")
    error_message = "public_subnet_id must start with 'subnet-'."
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
  default     = {}
}