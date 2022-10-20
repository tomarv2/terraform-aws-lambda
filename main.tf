resource "aws_lambda_function" "lambda" {
  for_each = var.lambda_config != null ? var.lambda_config : {}

  function_name                  = each.key
  description                    = try(each.value.description, "Terraform managed : ${var.teamid}-${var.prjid}")
  filename                       = each.value.output_path
  source_code_hash               = join("", [for sha in data.archive_file.zip : sha.output_base64sha256])
  role                           = each.value.role
  handler                        = each.value.handler
  reserved_concurrent_executions = try(each.value.reserved_concurrent_executions, null)
  runtime                        = try(each.value.runtime, null)
  memory_size                    = try(each.value.memory_size, 128)
  timeout                        = try(each.value.timeout, 30)
  layers                         = try(each.value.layers, null)
  kms_key_arn                    = try(each.value.kms_key_arn, null)
  image_uri                      = try(each.value.image_uri, null)
  package_type                   = try(each.value.package_type, "Zip")

  tags = merge(local.shared_tags)

  dynamic "environment" {
    for_each = try(each.value.environment, null) == null ? [] : [each.value.environment]
    content {
      variables = environment.value.variables
    }
  }

  dynamic "tracing_config" {
    for_each = try(each.value.tracing_config, null) == null ? [] : [each.value.tracing_config]
    content {
      mode = tracing_config.value.mode
    }
  }

  dynamic "vpc_config" {
    for_each = try(each.value.vpc_config, null) == null ? [] : [each.value.vpc_config]
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

  dynamic "dead_letter_config" {
    for_each = try(each.value.dead_letter_config, null) == null ? [] : [each.value.dead_letter_config]
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }

  dynamic "file_system_config" {
    for_each = try(each.value.file_system_arn, null) != null && try(each.value.file_system_local_mount_path, null) != null ? [true] : []
    content {
      local_mount_path = try(each.value.file_system_local_mount_path, null)
      arn              = try(each.value.file_system_arn, null)
    }
  }
}
