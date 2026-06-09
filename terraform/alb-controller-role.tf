data "aws_caller_identity" "current" {}

locals {
  alb_controller_role_name = "${var.project_name}-${var.environment}-alb-controller-role"
}

resource "aws_iam_role" "alb_controller" {
  name = local.alb_controller_role_name

assume_role_policy = jsonencode({
  Version = "2012-10-17"

  Statement = [
    {
      Effect = "Allow"

      Principal = {
        Federated = aws_iam_openid_connect_provider.eks.arn
      }

      Action = "sts:AssumeRoleWithWebIdentity"

      Condition = {
        StringEquals = {
          "${local.oidc_provider_url}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          "${local.oidc_provider_url}:aud" = "sts.amazonaws.com"
        }
      }
    }
  ]
})
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}