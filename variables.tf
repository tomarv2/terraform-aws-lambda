variable "teamid" {
  description = "(Required) name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
  type        = string
}

variable "prjid" {
  description = "(Required) name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
  type        = string
}

variable "role" {
  description = "IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to."
  default     = null
  type        = string
}

variable "handler" {
  description = "The function entrypoint in your code."
  type        = string
}

variable "runtime" {
  default     = ""
  description = "See Runtimes for valid values."
  type        = string
}

variable "environment" {
  description = "environment variables to pass to lambda."
  type = object({
    variables = map(string)
  })
  default = null
}

variable "memory_size" {
  default     = 128
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
  type        = number

}

variable "timeout" {
  default     = 30
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3."
  type        = number
}

variable "description" {
  default     = ""
  description = "Description of what your Lambda Function does."
  type        = string
}

variable "source_file" {
  description = "input file path on local machine to zip"
  default     = null
  type        = string
}

variable "source_dir" {
  description = "input directory path on local machine to zip"
  default     = null
  type        = string
}

variable "output_path" {
  description = "output file path on local machine to deploy to lambda"
  type        = string
}

variable "exclude_files" {
  description = "file(s) to exclude in directory from zipping"
  default     = null
  type        = list(any)
}

variable "archive_type" {
  description = "archive file type."
  default     = "zip"
  type        = string
}

variable "tracing_config" {
  description = "Tracing config."
  type = object({
    mode = string
  })
  default = {
    mode = "PassThrough"
  }
}

variable "vpc_config" {
  description = "vpc config."
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default = null
}

variable "dead_letter_config" {
  description = "dead letter config."
  type = object({
    target_arn = string
  })
  default = null
}

variable "reserved_concurrent_executions" {
  description = "reserved concurrent execution."
  type        = number
  default     = null
}

variable "layers" {
  description = "lambda layers."
  type        = list(string)
  default     = null
}

variable "cloudwatch_path" {
  description = "name of the log group"
  default     = "/aws/lambda"
  type        = string
}

variable "deploy_lambda" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "deploy_layer" {
  description = "Controls whether Lambda Layer resource should be created"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "The ARN of KMS key to use by your Lambda Function"
  type        = string
  default     = null
}

variable "package_type" {
  description = "The Lambda deployment package type. Valid options: Zip or Image"
  type        = string
  default     = "Zip"
}

variable "image_uri" {
  description = "The ECR image URI containing the function's deployment package."
  type        = string
  default     = null
}

variable "file_system_arn" {
  description = "The Amazon Resource Name (ARN) of the Amazon EFS Access Point that provides access to the file system."
  type        = string
  default     = null
}

variable "file_system_local_mount_path" {
  description = "The path where the function can access the file system, starting with /mnt/."
  type        = string
  default     = null
}

# Cloudwatch trigger
variable "deploy_cloudwatch_event_trigger" {
  description = "deploy cloud watch event trigger"

  type    = bool
  default = false
}

variable "profile_for_iam" {
  description = "profile to use for iam role creation."
  default     = "default"
  type        = string
}

variable "policy_identifier" {
  description = "iam policy identifier."
  default     = ["lambda.amazonaws.com"]
  type        = list(string)
}

variable "runtime_dependencies" {
  description = "feature flag install runtime dependencies."
  type        = bool
  default     = false
}

variable "dependencies_path" {
  description = "Location of dependencies management script."
  default     = null
  type        = string
}

variable "cloudwatch_event" {
  description = "Map of cloudwatch event configuration"
  type        = map(any)
  default = {
    default = {}
    default = {}
  }
}

variable "deploy_cloudwatch" {
  description = "feature flag, true or false"
  default     = true
  type        = bool
}

variable "aws_region" {
  description = "aws region to deploy resources"
  default     = null
  type        = string
}

variable "profile_to_use" {
  description = "Getting values from ~/.aws/credentials"
  default     = "default"
  type        = string
}
