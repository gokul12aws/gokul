terraform {
  backend "s3" {
    bucket = "gokul345672"
    key = "terraform/state/terraform.tf"
    region = "us-east-1"
  }
}
