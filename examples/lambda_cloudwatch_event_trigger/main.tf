module "lambda" {
  source = "git::git@github.com:tomarv2/terraform-aws-lambda.git"

  deploy_cloudwatch_event_trigger = true

  account_id = "123456789012"
  #
  # NOTE: One of the below is required:
  # existing `role` or
  # `profile_to_use_for_iam` and `policy_identifier`
  # `profile_to_use_for_iam`: to handle the case where deployment account does not have permission
  # to manage IAM
  #role             = "arn:aws:iam::123456789012:role/demo-role"
  profile_to_use_for_iam = "iam-admin"
  policy_identifier      = ["events.amazonaws.com", "cloudwatch.amazonaws.com", "lambda.amazonaws.com"]

  runtime = "python3.8"
  handler = "lambda_function.lambda_handler"
  #NOTE: `source_file` or `source_dir` and/or `exclude_files` is required
  #source_file      = "lambda_function.py"
  source_dir    = "demo_lambda"
  exclude_files = ["exclude_file.txt"]
  output_path   = "/tmp/test.zip"
  environment = {
    variables = {
      HELLO = "WORLD"
    }
  }

  # -----------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
