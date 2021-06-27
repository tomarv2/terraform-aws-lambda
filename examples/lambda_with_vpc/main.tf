module "global" {
  source = "git::git@github.com:tomarv2/terraform-global.git//aws?ref=v0.0.1"
}

module "common" {
  source = "git::git@github.com:tomarv2/terraform-global.git//common?ref=v0.0.1"
}

module "lambda" {
  source = "../../"

  # --------------------------------------------------
  # NOTE: One of the below is required:
  # - existing `role`
  # - `profile_for_iam` and `policy_identifier` (to handle the case where deployment account does not have permission to manage IAM)
  role = "arn:aws:iam::123456789012:role/demo-role"
  #profile_for_iam = "iam-admin"
  #policy_identifier      = ["events.amazonaws.com", "cloudwatch.amazonaws.com", "lambda.amazonaws.com"]

  # NOTE: One of the below is required:
  # - `source_file`
  # - `source_dir` and/or `exclude_files` and/or `runtime_dependencies`
  #source_file      = "lambda_function.py"
  source_dir           = "demo_lambda"
  exclude_files        = ["exclude_file.txt"]
  runtime_dependencies = true
  # --------------------------------------------------
  output_path = "/tmp/test.zip"

  runtime = "python3.8"
  handler = "lambda_function.lambda_handler"
  environment = {
    variables = {
      HELLO = "WORLD"
    }
  }
  # -----------------------------------------
  vpc_config = {
    subnet_ids         = module.global.list_of_subnets["123456789012"]["us-west-2"]
    security_group_ids = [module.security_group.security_group_id]
  }

  # -----------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

module "security_group" {
  source = "git::git@github.com:tomarv2/terraform-aws-security-group.git?ref=v0.0.2"

  account_id = "123456789012"
  security_group_ingress = {
    default = {
      description = "https"
      from_port   = 443
      protocol    = "tcp"
      type        = "ingress"
      to_port     = 443
      self        = true
      cidr_blocks = []
    },
    ssh = {
      description = "ssh"
      from_port   = 22
      protocol    = "tcp"
      type        = "ingress"
      to_port     = 22
      self        = false
      cidr_blocks = module.common.cidr_for_sec_grp_access
    }
  }
  #-------------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
