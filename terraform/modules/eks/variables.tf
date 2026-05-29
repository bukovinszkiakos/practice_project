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

variable "cluster_role_arn" {
  type        = string
  description = "IAM role ARN for the EKS cluster."

  validation {
    condition     = startswith(var.cluster_role_arn, "arn:aws:iam::")
    error_message = "cluster_role_arn must be a valid IAM role ARN."
  }
}

variable "node_role_arn" {
  type        = string
  description = "IAM role ARN for the EKS node group."

  validation {
    condition     = startswith(var.node_role_arn, "arn:aws:iam::")
    error_message = "node_role_arn must be a valid IAM role ARN."
  }
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs used by the EKS cluster."

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two subnet IDs are required for EKS."
  }

  validation {
    condition = alltrue([
      for subnet_id in var.subnet_ids :
      startswith(subnet_id, "subnet-")
    ])
    error_message = "All subnet_ids must start with 'subnet-'."
  }
}

variable "node_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs where EKS worker nodes will run."

  validation {
    condition     = length(var.node_subnet_ids) >= 1
    error_message = "At least one node subnet ID is required."
  }

  validation {
    condition = alltrue([
      for subnet_id in var.node_subnet_ids :
      startswith(subnet_id, "subnet-")
    ])
    error_message = "All node_subnet_ids must start with 'subnet-'."
  }
}

variable "endpoint_private_access" {
  type        = bool
  description = "Enable private API server endpoint access."
  default     = true
}

variable "endpoint_public_access" {
  type        = bool
  description = "Enable public API server endpoint access."
  default     = true
}

variable "instance_types" {
  type        = list(string)
  description = "EC2 instance types for the EKS node group."
  default     = ["t3.small"]

  validation {
    condition     = length(var.instance_types) > 0
    error_message = "At least one instance type must be provided."
  }
}

variable "capacity_type" {
  type        = string
  description = "Capacity type for EKS node group."
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "capacity_type must be either ON_DEMAND or SPOT."
  }
}

variable "desired_size" {
  type        = number
  description = "Desired number of worker nodes."
  default     = 2
}

variable "min_size" {
  type        = number
  description = "Minimum number of worker nodes."
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes."
  default     = 3
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