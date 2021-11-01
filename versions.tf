terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      version = ">= 3.63"
    }
    archive = {
      version = ">= 2.1"
    }
    null = {
      version = ">= 3.1.0"
    }
  }
}
