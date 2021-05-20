resource "aws_lambda_function" "lambda" {
  count = var.deploy && var.deploy_function && !var.deploy_layer ? 1 : 0

  function_name                  = "${var.teamid}-${var.prjid}"
  description                    = var.description == "" ? "Managed by Terraform: ${var.teamid}-${var.prjid}" : var.description
  filename                       = var.source_file != null ? join("", data.archive_file.zip_file.*.output_path) : join("", data.archive_file.zip_dir.*.output_path)
  source_code_hash               = var.source_file != null ? join("", data.archive_file.zip_file.*.output_base64sha256) : join("", data.archive_file.zip_dir.*.output_base64sha256)
  role                           = var.role == null ? module.iam_role.iam_role_arn : var.role
  handler                        = var.package_type != "Zip" ? null : var.handler
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.package_type != "Zip" ? null : var.runtime
  memory_size                    = var.memory_size == "" ? "null" : var.memory_size
  timeout                        = var.timeout == "" ? "null" : var.timeout
  layers                         = var.layers
  kms_key_arn                    = var.kms_key_arn
  image_uri                      = var.image_uri
  package_type                   = var.package_type

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

  dynamic "file_system_config" {
    for_each = var.file_system_arn != null && var.file_system_local_mount_path != null ? [true] : []
    content {
      local_mount_path = var.file_system_local_mount_path
      arn              = var.file_system_arn
    }
  }
}
