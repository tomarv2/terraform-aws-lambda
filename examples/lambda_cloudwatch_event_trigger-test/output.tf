output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda.lambda_arn
}

output "lambda_iam_role_arn" {
  description = "ARN of IAM role used by Lambda function"
  value       = module.lambda.lambda_iam_role_arn
}

output "input_file_name" {
  description = "Source code location"
  value       = module.lambda.input_file_name
}

output "output_file_path" {
  description = "Output filepath location"
  value       = module.lambda.output_file_path
}

output "output_file_size" {
  description = "Output filepath size"
  value       = module.lambda.output_file_size
}

output "cloudwatch_lambda_permissions" {
  value = module.lambda.cloudwatch_lambda_permissions
}