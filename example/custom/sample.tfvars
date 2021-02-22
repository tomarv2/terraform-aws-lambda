email                       = "demo@demo.com"
profile_to_use              = "default"
account_id                  = "123456789012"
aws_region                  = "us-west-2"
#-------------------------------------------------------------------
# CUSTOMIZE
#-------------------------------------------------------------------
function_name               = "hello-world"
function_timeout            = 60
function_memory             = 256
role_arn                    = "arn:aws:iam::123456789012:role/lambda-basic-execution"
runtime                     = "python3.8"
handler                     = "lambda_function.lambda_handler"
source_file                 = "../custom/lambda_function.py"
output_file_path            = "/tmp/test.zip"
description                 = "hello world"
environment_vars            = {
                                "HELLO" = "WORLD"
                              }
# ------------------------------------------------------------------
# Do not change the teamid, prjid once set.
teamid                      = "rumse"
prjid                       = "demo-lambda"

