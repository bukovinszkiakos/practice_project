variable "region" {
  type        = string
  description = "AWS region where the Terraform backend resources will be created."

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "region cannot be empty."
  }
}

variable "state_bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name for storing Terraform state."

  validation {
    condition     = length(trimspace(var.state_bucket_name)) >= 3 && length(trimspace(var.state_bucket_name)) <= 63
    error_message = "state_bucket_name must be between 3 and 63 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.state_bucket_name))
    error_message = "state_bucket_name must contain only lowercase letters, numbers, dots, and hyphens, and must start/end with a letter or number."
  }
}

variable "lock_table_name" {
  type        = string
  description = "DynamoDB table name used for Terraform state locking."

  validation {
    condition     = length(trimspace(var.lock_table_name)) > 0
    error_message = "lock_table_name cannot be empty."
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to Terraform backend resources."
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.common_tags :
      length(trimspace(key)) > 0 && length(trimspace(value)) > 0
    ])
    error_message = "common_tags keys and values cannot be empty."
  }
}