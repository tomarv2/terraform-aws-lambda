terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      version = "~> 3.30"
    }
    archive = {
      version = "~> 2.2.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.profile_to_use
}
