terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
   backend "remote" {
    organization = "pogbiatest"

    workspaces {
      name = "aws-example"
    }
  }
}


provider "aws" {
  region  = var.aws_region
  #profile = "default"
  access_key = var.access_key
  secret_key = var.secret_key
}

