locals {
  profile_to_use = var.role != null ? var.role : var.profile_for_iam
}


terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      version = "~> 3.47"
    }
    archive = {
      version = "~> 2.1"
    }
    null = {
      version = "~> 3.1.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.profile_to_use
}

provider "aws" {
  alias   = "iam-management"
  region  = var.aws_region
  profile = local.profile_to_use
}
