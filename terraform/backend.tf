terraform {
  backend "s3" {
    bucket         = "practice-project-dev-terraform-state-akos"
    key            = "practice-project/dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "practice-project-dev-terraform-locks"
    encrypt        = true
  }
}