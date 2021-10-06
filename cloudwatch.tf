module "cloudwatch" {
  source = "git::git@github.com:tomarv2/terraform-aws-cloudwatch.git?ref=v0.0.4"

  cloudwatch_path = var.cloudwatch_path
  teamid          = var.teamid
  prjid           = var.prjid
}
