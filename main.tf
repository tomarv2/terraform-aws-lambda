locals {
  shared_tags = map(
    "Name", "${var.teamid}-${var.prjid}",
    "Owner", var.email,
    "Team", var.teamid,
    "Project", var.prjid
  )
}
