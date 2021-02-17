terraform {
  required_version            = ">= 0.14"
  required_providers {
    aws = {
      version                     = "~> 2.61"
    }
  }
}

provider "aws" {
  region                      = var.aws_region
  profile                     = var.profile_to_use
}

locals {
  shared_tags  = map(
      "Name", "${var.teamid}-${var.prjid}",
      "Owner", var.email,
      "Team", var.teamid,
      "Project", var.prjid
  )
}
