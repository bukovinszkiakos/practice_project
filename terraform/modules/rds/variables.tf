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

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the RDS subnet group."

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two private subnet IDs are recommended for RDS."
  }

  validation {
    condition = alltrue([
      for subnet_id in var.subnet_ids :
      startswith(subnet_id, "subnet-")
    ])
    error_message = "All subnet_ids must start with 'subnet-'."
  }
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs attached to the RDS instance."

  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "At least one security group ID is required."
  }

  validation {
    condition = alltrue([
      for sg_id in var.security_group_ids :
      startswith(sg_id, "sg-")
    ])
    error_message = "All security_group_ids must start with 'sg-'."
  }
}

variable "db_name" {
  type        = string
  description = "Database name."

  validation {
    condition     = length(trimspace(var.db_name)) > 0
    error_message = "db_name cannot be empty."
  }
}

variable "db_username" {
  type        = string
  description = "Master database username."
  sensitive   = true

  validation {
    condition     = length(trimspace(var.db_username)) > 0
    error_message = "db_username cannot be empty."
  }
}

variable "db_password" {
  type        = string
  description = "Master database password."
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "db_password must be at least 8 characters long."
  }
}

variable "db_port" {
  type        = number
  description = "Database port."
  default     = 5432
}

variable "engine_version" {
  type        = string
  description = "PostgreSQL engine version."
  default     = "16.3"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class."
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "Initial allocated storage in GB."
  default     = 20
}

variable "max_allocated_storage" {
  type        = number
  description = "Maximum allocated storage in GB."
  default     = 50
}

variable "storage_type" {
  type        = string
  description = "RDS storage type."
  default     = "gp3"

  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.storage_type)
    error_message = "storage_type must be one of: gp2, gp3, io1, io2."
  }
}

variable "multi_az" {
  type        = bool
  description = "Whether RDS should run in Multi-AZ mode."
  default     = false
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days to retain backups."
  default     = 7
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Whether to skip final snapshot when deleting the DB."
  default     = true
}

variable "deletion_protection" {
  type        = bool
  description = "Whether deletion protection is enabled."
  default     = false
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