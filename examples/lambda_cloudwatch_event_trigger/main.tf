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
  cloudwatch_event = [
    {
      name         = "demo"
      description  = "demo: ${var.teamid}-${var.prjid}"
      schedule     = "rate(1 day)"
      custom_input = { "sourceVersion" = "dev", "timeoutInMinutesOverride" = 30 }
      suffix       = "demo"
    },
    {
      name         = "sample"
      description  = "sample: ${var.teamid}-${var.prjid}"
      schedule     = "rate(2 days)"
      custom_input = { "sourceVersion" = "main", "timeoutInMinutesOverride" = 60 }
      suffix       = "sample"
    }
  ]
  # -----------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}
