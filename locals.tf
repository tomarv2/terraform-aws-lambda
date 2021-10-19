locals {
  shared_tags = tomap(
    {
      "Name"    = "${var.teamid}-${var.prjid}",
      "team"    = var.teamid,
      "project" = var.prjid
    }
  )

  override_aws_region = var.aws_region != null ? var.aws_region : data.aws_region.current.name
}

data "aws_region" "current" {}

