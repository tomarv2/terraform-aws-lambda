output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.lambda.arn
}

output "lambda_role" {
  description = "IAM role used by Lambda function"
  value       = aws_lambda_function.lambda.role
}

output "input_file_name" {
  description = "Source code location"
  value       = data.archive_file.zip.source_file
}

output "output_file_path" {
  description = "Output filepath location"
  value       = data.archive_file.zip.output_path
}

output "output_file_size" {
  description = "Output filepath size"
  value       = data.archive_file.zip.output_size
}
