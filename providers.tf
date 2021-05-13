terraform {
 required_providers {
  aws = {
   source  = "hashicorp/aws"
   version = "~> 3.27"
  }
 }
}

provider "aws" {
 profile = "raksit31667-terraform"
 region = "ap-southeast-1"
}