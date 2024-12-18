terraform {
  backend "s3" {
    bucket = "gokkul-12345"
    key = "terraform/state/terraform.tfstate"
    region = "us-east-1"
  }
}
