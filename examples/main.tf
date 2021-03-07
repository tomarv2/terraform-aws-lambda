module "lambda" {
  source = "../"

  email          = "varun.tomar@databricks.com"
  profile_to_use = "default"
account_id     = "755921336062"
aws_region     = "us-west-2"
role           = "arn:aws:iam::755921336062:role/S3-SecretsScanner-LambdaRole20200608213733829700000002"
description    = "demo lambda deployment"
runtime          = "python3.8"
handler          = "lambda_function.lambda_handler"
source_file      = "../test_data/lambda_function.py"
output_file_path = "/tmp/test.zip"

  environment_vars = {
  "HELLO" = "WORLD"
}
  # ------------------------------------------------------------------
  # Do not change the teamid, prjid once set.
  teamid         = var.teamid
  prjid          = var.prjid
}

