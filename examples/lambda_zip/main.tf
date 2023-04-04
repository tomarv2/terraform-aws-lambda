terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      version = "~> 4.61"
    }
  }
}

provider "aws" {
  region = var.region
}

module "lambda" {
  source = "../../"

  config = {
    "demo_lambda" = {
      role                 = var.role_arn
      source_dir           = "demo_lambda"
      exclude_files        = ["exclude_file.txt"]
      runtime_dependencies = false
      output_path          = "/tmp/test.zip"

      runtime = "python3.8"
      handler = "lambda_function.lambda_handler"
      environment = {
        variables = {
          HELLO = "WORLD"
        }
      }
    }
  }
  teamid = var.teamid
  prjid  = var.prjid
}

module "cloudwatch" {
  source = "github.com/tomarv2/terraform-aws-cloudwatch.git"

  cloudwatch_config = {
    "/aws/lambda/${module.lambda.function_name}" = {
      retention_in_days = 7
    }
  }
  teamid = var.teamid
  prjid  = var.prjid
}

module "cloudwatch_event" {
  source = "github.com/tomarv2/terraform-aws-cloudwatch-events.git"

  cloudwatch_event_config = {
    (module.lambda.function_name) = {
      service_role = var.role_arn
      target_arn   = join("", module.lambda.arn)
    }
  }
  teamid = var.teamid
  prjid  = var.prjid
}

resource "aws_lambda_permission" "cloudwatch" {
  for_each = module.cloudwatch_event

  statement_id  = "allow_cloudwatch_${each.key}_trigger"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = join("", each.value)
}
