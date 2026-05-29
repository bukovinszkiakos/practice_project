variable "region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    public            = bool
  }))
}

variable "eks_ingress_rules" {
  description = "Ingress rules for EKS security group."

  type = list(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = list(string)
    security_groups = list(string)
  }))

  default = []
}

variable "db_port" {
  type        = number
  description = "Database port."
  default     = 5432
}

variable "eks_security_group_name" {
  type    = string
  default = "eks"
}

variable "eks_security_group_description" {
  type    = string
  default = "Security group for EKS nodes"
}

variable "rds_security_group_name" {
  type    = string
  default = "rds"
}

variable "rds_security_group_description" {
  type    = string
  default = "Security group for RDS PostgreSQL"
}

variable "repository_names" {
  type        = list(string)
  description = "List of ECR repository name suffixes."
}

variable "image_tag_mutability" {
  type        = string
  description = "Whether image tags are mutable or immutable."
  default     = "MUTABLE"
}

variable "scan_on_push" {
  type        = bool
  description = "Whether ECR should scan images when pushed."
  default     = true
}

variable "endpoint_private_access" {
  type    = bool
  default = true
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}

variable "eks_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "eks_capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "eks_desired_size" {
  type    = number
  default = 2
}

variable "eks_min_size" {
  type    = number
  default = 1
}

variable "eks_max_size" {
  type    = number
  default = 3
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_engine_version" {
  type    = string
  default = "16.3"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_max_allocated_storage" {
  type    = number
  default = 50
}

variable "db_storage_type" {
  type    = string
  default = "gp3"
}

variable "db_multi_az" {
  type    = bool
  default = false
}

variable "db_backup_retention_period" {
  type    = number
  default = 7
}

variable "db_skip_final_snapshot" {
  type    = bool
  default = true
}

variable "db_deletion_protection" {
  type    = bool
  default = false
}