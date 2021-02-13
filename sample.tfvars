email                       = "demo@demo"
profile_to_use              = "default"
role                        = "arn:aws:iam::123456789012:role/lambda-execution-role"
description                 = "demo lambda deployment"
account_id                  = "123456789012"
aws_region                  = "us-west-2"
#-------------------------------------------------------------------
# CUSTOMIZE
#-------------------------------------------------------------------
runtime                     = "python3.8"
handler                     = "lambda_function.lambda_handler"
source_file                 = "../lambda_function.py"
output_file_path            = "/tmp/test.zip"
# ------------------------------------------------------------------
# Do not change the teamid, prjid once set.
teamid                      = "demo"
prjid                       = "demo-lambda"

