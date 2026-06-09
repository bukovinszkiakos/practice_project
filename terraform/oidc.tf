data "tls_certificate" "eks_oidc" {
  url = module.eks.oidc_issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = module.eks.oidc_issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]
}

locals {
  oidc_provider_url = replace(
    module.eks.oidc_issuer,
    "https://",
    ""
  )
}