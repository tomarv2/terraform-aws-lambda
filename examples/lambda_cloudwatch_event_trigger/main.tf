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
  # --------------------------------------------------
  deploy_cloudwatch_event_trigger = true
  cloudwatch_event = {
    project-alpha = {
      description  = "alpha"
      schedule     = "rate(2 days)"
      custom_input = { "sourceVersion" = "main", "timeoutInMinutesOverride" = 66 }
      suffix       = "alpha"
    },
    project-beta = {
      description  = "beta"
      schedule     = "rate(3 days)"
      custom_input = { "sourceVersion" = "main", "timeoutInMinutesOverride" = 770 }
      suffix       = "beta"
    }
  }
  # -----------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
