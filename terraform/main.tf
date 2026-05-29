module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  common_tags  = var.common_tags
}

module "subnet" {
  source = "./modules/subnets"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  subnets      = var.subnets
  common_tags  = var.common_tags
}

module "internet_gateway" {
  source = "./modules/internet_gateway"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  common_tags  = var.common_tags
}

module "nat-gateway" {
  source = "./modules/nat-gateway"

  project_name     = var.project_name
  environment      = var.environment
  public_subnet_id = module.subnet.public_subnet_ids[0]
  common_tags      = var.common_tags
}

module "route_table" {
  source = "./modules/route_table"

  project_name = var.project_name
  environment  = var.environment

  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  nat_gateway_id      = module.nat-gateway.nat_gateway_id

  public_subnet_ids  = module.subnet.public_subnet_ids
  private_subnet_ids = module.subnet.private_subnet_ids

  common_tags = var.common_tags
}


locals {
  rds_ingress_rules = [
    {
      description     = "Allow PostgreSQL from EKS security group"
      from_port       = var.db_port
      to_port         = var.db_port
      protocol        = "tcp"
      cidr_blocks     = []
      security_groups = [module.eks_security_group.security_group_id]
    }
  ]
}


module "eks_security_group" {
  source = "./modules/security_group"

  project_name = var.project_name
  environment  = var.environment
  name         = var.eks_security_group_name
  description  = var.eks_security_group_description
  vpc_id       = module.vpc.vpc_id

  ingress_rules = var.eks_ingress_rules

  common_tags = var.common_tags
}

module "rds_security_group" {
  source = "./modules/security_group"

  project_name = var.project_name
  environment  = var.environment
  name         = var.rds_security_group_name
  description  = var.rds_security_group_description
  vpc_id       = module.vpc.vpc_id

  ingress_rules = local.rds_ingress_rules

  common_tags = var.common_tags
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment

  repository_names     = var.repository_names
  image_tag_mutability = var.image_tag_mutability
  scan_on_push         = var.scan_on_push

  common_tags = var.common_tags
}


module "eks" {
  source = "./modules/eks"

  project_name = var.project_name
  environment  = var.environment

  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn

  subnet_ids      = concat(module.subnet.public_subnet_ids, module.subnet.private_subnet_ids)
  node_subnet_ids = module.subnet.private_subnet_ids

  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access  = var.endpoint_public_access

  instance_types = var.eks_instance_types
  capacity_type  = var.eks_capacity_type

  desired_size = var.eks_desired_size
  min_size     = var.eks_min_size
  max_size     = var.eks_max_size

  common_tags = var.common_tags
}


module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment

  subnet_ids         = module.subnet.private_subnet_ids
  security_group_ids = [module.rds_security_group.security_group_id]

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_port     = var.db_port

  engine_version        = var.db_engine_version
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_type          = var.db_storage_type

  multi_az                = var.db_multi_az
  backup_retention_period = var.db_backup_retention_period
  skip_final_snapshot     = var.db_skip_final_snapshot
  deletion_protection     = var.db_deletion_protection

  common_tags = var.common_tags
}