terraform {
  backend "s3" {
    bucket = "gokul34567"
    key = "terraform/state/terraform.tf"
    region = "us-east-1"
  }
}
