locals {
  db_subnet_group_name = "${var.project_name}-${var.environment}-db-subnet-group"
  db_identifier        = "${var.project_name}-${var.environment}-postgres"
}

resource "aws_db_subnet_group" "this" {
  name       = local.db_subnet_group_name
  subnet_ids = var.subnet_ids

  tags = merge(var.common_tags, {
    Name = local.db_subnet_group_name
  })
}

resource "aws_db_instance" "this" {
  identifier = local.db_identifier

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  port = var.db_port

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids

  publicly_accessible = false
  multi_az            = var.multi_az

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  tags = merge(var.common_tags, {
    Name = local.db_identifier
  })
}