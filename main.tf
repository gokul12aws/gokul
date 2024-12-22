terraform {
  backend "s3" {
    bucket          = "gokkul-12345"
    key             = "networking/terraform.tfstate"
    region          = ""
    dynamodb_table  = ""
    encrypt         = true
   }
   required_providers {
     aws = {
       source  = "hashicorp/aws"
       version = "~> 4.0"
      }
     }
   }

provider "aws" {
  region = "us-"
}

module "compute" {
  source      = "./compute"

}

module "networking" {
  source     = "./networking"

}


  
  
  
