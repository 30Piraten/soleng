terraform {
  backend "s3" {
    encrypt = true
    region = "us-east-1"
    bucket = "terraform-state-bucket"
    key = "cicd-pipeline/terraform.tfstate"
  }
}