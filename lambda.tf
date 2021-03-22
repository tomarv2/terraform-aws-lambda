resource "aws_lambda_function" "lambda" {
  function_name    = "${var.teamid}-${var.prjid}"
  description = var.description == "" ? "Managed by Terraform: ${var.teamid}-${var.prjid}" : var.description
  filename         = data.archive_file.zip.output_path
  role             = var.role
  handler          = var.handler
  source_code_hash = data.archive_file.zip.output_base64sha256
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime     = var.runtime == "" ? "null" : var.runtime
  memory_size = var.memory_size == "" ? "null" : var.memory_size
  timeout     = var.timeout == "" ? "null" : var.timeout
  layers                         = var.layers

  tags = merge(local.shared_tags)

  dynamic "environment" {
    for_each = var.environment == null ? [] : [var.environment]
    content {
      variables = environment.value.variables
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config == null ? [] : [var.tracing_config]
    content {
      mode = tracing_config.value.mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config == null ? [] : [var.dead_letter_config]
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }

  depends_on = [data.archive_file.zip]
}
