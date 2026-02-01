terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket112"
    key            = "eks/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock11"
    encrypt        = true
  }
}
