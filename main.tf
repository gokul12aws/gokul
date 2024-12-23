terraform {
  backend "s3" {
    bucket          = "gokkul-12345"
    key             = "networking/terraform.tfstate"
    region          = "us-east-1" #N.virginia
    dynamodb_table  = "dynamo-table"
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


  
  
  
