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

variable "name" {
  type        = string
  description = "Security group name suffix."

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name cannot be empty."
  }
}

variable "description" {
  type        = string
  description = "Security group description."
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the security group will be created."

  validation {
    condition     = startswith(var.vpc_id, "vpc-")
    error_message = "vpc_id must start with 'vpc-'."
  }
}

variable "ingress_rules" {
  description = "Inbound security group rules."

  type = list(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = list(string)
    security_groups = list(string)
  }))

  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      rule.from_port <= rule.to_port
    ])
    error_message = "from_port must be less than or equal to to_port."
  }
}

variable "egress_rules" {
  description = "Outbound security group rules."

  type = list(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = list(string)
    security_groups = list(string)
  }))

  default = [
    {
      description     = "Allow all outbound traffic"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
    }
  ]

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      rule.from_port <= rule.to_port
    ])
    error_message = "from_port must be less than or equal to to_port."
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
  default     = {}
}