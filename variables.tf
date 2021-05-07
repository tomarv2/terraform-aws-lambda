variable "teamid" {
  description = "(Required) name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
}

variable "prjid" {
  description = "(Required) name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
}

variable "profile_to_use" {
  description = "Getting values from ~/.aws/credentials"
  default     = "default"
}

variable "account_id" {}

variable "aws_region" {
  default = "us-west-2"
}

variable "role" {
  description = "IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to."
  default     = null
}

variable "handler" {
  description = "The function entrypoint in your code."
}

variable "runtime" {
  default     = ""
  description = "See Runtimes for valid values."
}

variable "environment" {
  type = object({
    variables = map(string)
  })
  default = null
}

variable "memory_size" {
  default     = 128
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
}

variable "timeout" {
  default     = 30
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3."
}

variable "description" {
  default     = ""
  description = "Description of what your Lambda Function does."
}

variable "performance_mode" {
  description = "The performance mode of your file system."
  default     = "generalPurpose"
}

variable "source_file" {}

variable "output_file_path" {}

variable "archive_type" {
  default = "zip"
}

variable "tracing_config" {
  type = object({
    mode = string
  })
  default = {
    mode = "PassThrough"
  }
}

variable "vpc_config" {
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default = null
}

variable "dead_letter_config" {
  type = object({
    target_arn = string
  })
  default = null
}

variable "reserved_concurrent_executions" {
  type    = number
  default = null
}

variable "layers" {
  type    = list(string)
  default = null
}

variable "cloudwatch_path" {
  description = "name of the log group"
  default     = "aws/lambda"
}

variable "deploy" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "deploy_package" {
  description = "Controls whether Lambda package should be created"
  type        = bool
  default     = true
}

variable "deploy_function" {
  description = "Controls whether Lambda Function resource should be created"
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
  type    = bool
  default = false
}

variable "source_arn" {
  default = null
}

variable "profile_to_use_for_iam" {
  default = "default"
}

variable "policy_identifier" {
  default = ["lambda.amazonaws.com"]
}