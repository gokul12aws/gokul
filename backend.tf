terraform {
  backend "s3" {
    bucket = "gokul"
    key = "terraform/state/terraform.tf"
    region = "us-west-1"
  }
}
