module "lambda" {
  source = "../../"

  account_id       = "123456789012"
  role             = "arn:aws:iam::123456789012:role/LambdaExecutionRole"
  runtime          = "python3.8"
  handler          = "lambda_function.lambda_handler"
  source_file      = "lambda_function.py"
  output_file_path = "/tmp/test.zip"
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
