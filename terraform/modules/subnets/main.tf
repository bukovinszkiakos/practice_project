resource "aws_subnet" "this" {
  for_each = var.subnets

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.public

  tags = merge(
    var.common_tags,

    {
      Name = "${var.project_name}-${var.environment}-${each.key}"
      Type = each.value.public ? "public" : "private"

      "kubernetes.io/cluster/${var.project_name}-${var.environment}-eks" = "shared"
    },

    each.value.public ? {
      "kubernetes.io/role/elb" = "1"
    } : {
      "kubernetes.io/role/internal-elb" = "1"
    }
  )
}