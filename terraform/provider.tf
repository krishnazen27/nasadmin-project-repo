terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "skr-backend-terraform-state-bucket"
    key    = "terraform/state/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}


provider "aws" {
  region = var.region
}

