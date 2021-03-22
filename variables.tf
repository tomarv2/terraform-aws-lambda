# Additional documentation: https://www.terraform.io/docs/configuration/variables.html
variable "teamid" {
  description = "(Required) name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
}

variable "prjid" {
  description = "(Required) name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
}

variable "email" {
  description = "email address to be used for tagging (suggestion: use group email address)"
}

variable "profile_to_use" {
  description = "Getting values from ~/.aws/credentials"
  default = "default"
}

variable "account_id" {}

variable "aws_region" {
  default = "us-west-2"
}

variable "role" {
  description = "IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to."
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