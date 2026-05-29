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

variable "repository_names" {
  type        = list(string)
  description = "List of ECR repository name suffixes."

  validation {
    condition     = length(var.repository_names) > 0
    error_message = "At least one ECR repository name must be provided."
  }

  validation {
    condition = alltrue([
      for name in var.repository_names :
      length(trimspace(name)) > 0
    ])
    error_message = "Repository names cannot be empty."
  }
}

variable "image_tag_mutability" {
  type        = string
  description = "Whether image tags are mutable or immutable."
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  type        = bool
  description = "Whether ECR should scan images when pushed."
  default     = true
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