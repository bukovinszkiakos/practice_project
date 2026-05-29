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

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.common_tags :
      length(trimspace(key)) > 0 && length(trimspace(value)) > 0
    ])
    error_message = "common_tags keys and values cannot be empty."
  }
}