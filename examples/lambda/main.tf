terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      version = "~> 3.74"
    }
  }
}

provider "aws" {
  region = var.region
}

module "lambda" {
  source = "../../"
  # --------------------------------------------------
  # NOTE: One of the below is required:
  # - existing `role`
  # - `profile_for_iam` and `policy_identifier` (to handle the case where deployment account does not have permission to manage IAM)
  role = "arn:aws:iam::123456789012:role/demo-role"
  #profile_for_iam      = "iam-admin"
  #policy_identifier    = ["events.amazonaws.com", "cloudwatch.amazonaws.com", "lambda.amazonaws.com"]

  # NOTE: One of the below is required:
  # - `source_file`
  # - `source_dir` and/or `exclude_files` and/or `runtime_dependencies`
  source_file = "lambda_function.py"
  #source_dir           = "demo_lambda"
  #exclude_files        = ["exclude_file.txt"]
  #runtime_dependencies = false
  # --------------------------------------------------
  output_path = "/tmp/test.zip"

  runtime = "python3.8"
  handler = "lambda_function.lambda_handler"
  environment = {
    variables = {
      HELLO = "WORLD"
    }
  }
  # --------------------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
