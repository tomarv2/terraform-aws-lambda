resource "aws_lambda_function" "lambda" {
  filename         = data.archive_file.zip.output_path
  function_name    = "${var.teamid}-${var.prjid}"
  role             = var.role
  handler          = var.handler
  source_code_hash = data.archive_file.zip.output_base64sha256

  runtime     = var.runtime == "" ? "null" : var.runtime
  memory_size = var.memory_size == "" ? "null" : var.memory_size
  timeout     = var.timeout == "" ? "null" : var.timeout
  description = var.description == "" ? "null" : var.description

  tags = merge(local.shared_tags)

  environment {
    variables = var.environment_vars
  }
  tracing_config {
    mode = "PassThrough"
  }
}
