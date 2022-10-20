output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda.arn
}

output "source_file" {
  description = "Lambda source code location"
  value       = module.lambda.source_file
}

output "output_path" {
  description = "Output file path location"
  value       = module.lambda.output_path
}

output "output_size" {
  description = "Output file size"
  value       = module.lambda.output_size
}

output "source_dir" {
  description = "Source code location"
  value       = module.lambda.source_dir
}

output "cw_log_name" {
  value = module.cloudwatch.log_group_name
}

output "cw_log_arn" {
  value = module.cloudwatch.log_group_arn
}