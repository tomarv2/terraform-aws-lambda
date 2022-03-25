output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = join("", aws_lambda_function.lambda.*.arn)
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = join("", aws_lambda_function.lambda.*.function_name)
}

output "lambda_iam_role_arn" {
  description = "ARN of IAM role used by Lambda function"
  value       = module.iam_role.iam_role_arn
}

output "input_file_name" {
  description = "Source code location"
  value       = join("", data.archive_file.zip_file.*.source_file)
}

output "output_file_path" {
  description = "Output file path location"
  value       = join("", data.archive_file.zip_file.*.output_path)
}

output "output_file_size" {
  description = "Output file path size"
  value       = join("", data.archive_file.zip_file.*.output_size)
}

output "input_dir_name" {
  description = "Source code location"
  value       = join("", data.archive_file.zip_dir.*.source_dir)
}

output "output_dir_path" {
  description = "Output dir path location"
  value       = join("", data.archive_file.zip_dir.*.output_path)
}

output "output_dir_size" {
  description = "Output dir path size"
  value       = join("", data.archive_file.zip_dir.*.output_size)
}
