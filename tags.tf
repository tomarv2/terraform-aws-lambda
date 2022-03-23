locals {
  shared_tags = tomap(
    {
      "Name"    = "${var.teamid}-${var.prjid}",
      "Team"    = var.teamid,
      "Project" = var.prjid
    }
  )
}
