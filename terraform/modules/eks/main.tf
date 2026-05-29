locals {
  cluster_name    = "${var.project_name}-${var.environment}-eks"
  node_group_name = "${var.project_name}-${var.environment}-node-group"
}

resource "aws_eks_cluster" "this" {
  name     = local.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
  }

  tags = merge(var.common_tags, {
    Name = local.cluster_name
  })
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = local.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.node_subnet_ids

  instance_types = var.instance_types
  capacity_type  = var.capacity_type

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  tags = merge(var.common_tags, {
    Name = local.node_group_name
  })

  depends_on = [
    aws_eks_cluster.this
  ]
}