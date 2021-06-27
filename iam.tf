module "iam_role" {
  source = "git::git@github.com:tomarv2/terraform-aws-iam-role.git//modules/iam_role_instance?ref=v0.0.4"

  deploy_iam_role             = var.role != null ? false : true
  deploy_iam_instance_profile = var.role != null ? false : true

  role_type         = "Service"
  policy_identifier = var.policy_identifier
  policy_arn        = var.role == null ? ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"] : []
  #-----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid

  providers = {
    aws = aws.iam-management
  }
}

module "iam_role_existing" {
  source = "git::git@github.com:tomarv2/terraform-aws-iam-role.git//modules/iam_role_instance?ref=v0.0.4"

  deploy_iam_role             = false
  deploy_iam_instance_profile = false
  existing_role_name          = module.iam_role.iam_role_name
  policy_arn                  = var.vpc_config != null ? ["arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"] : []
  #-----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid

  providers = {
    aws = aws.iam-management
  }
}
