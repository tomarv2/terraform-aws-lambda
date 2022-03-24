terraform {
  required_version = ">= 1.0.67124444455555666666"
  required_providers {
    aws = {
      version = "~> 3.74"
    }
    archive = {
      version = ">= 2.1"
    }
    null = {
      version = ">= 3.1.0"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.1.0"
    }
  }
}
