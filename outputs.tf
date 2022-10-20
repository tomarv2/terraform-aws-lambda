output "arn" {
  description = "ARN of the Lambda function"
  value       = [for lambda in aws_lambda_function.lambda : lambda.arn]
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = join("", [for lambda in aws_lambda_function.lambda : lambda.function_name])
}

output "source_file" {
  description = "Lambda source code location"
  value       = try(join("", [for lambda in data.archive_file.zip : lambda.source_file]), null)
}

output "output_path" {
  description = "Output file path location"
  value       = join("", [for lambda in data.archive_file.zip : lambda.output_path])
}

output "output_size" {
  description = "Output file size"
  value       = join("", [for lambda in data.archive_file.zip : lambda.output_size])
}

output "source_dir" {
  description = "Source code location"
  value       = try(join("", [for lambda in data.archive_file.zip : lambda.source_dir]), null)
}
