# Additional documentation: https://www.terraform.io/docs/configuration/variables.html
variable "teamid" {
  description = "(Required) Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
}

variable "prjid" {
  description = "(Required) Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
}

variable "email" {
  description = "email address to be used for tagging (suggestion: use group email address)"
}

variable "profile_to_use" {
  description = "Getting values from ~/.aws/credentials"
}

variable "account_id" {}

variable "aws_region" {
  default = "us-west-2"
}

variable "role" {
  description = "(Required) IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to."
}

variable "handler" {
  description = "(Required) The function entrypoint in your code."
}

variable "runtime" {
  default = ""
  description = "(Required) See Runtimes for valid values."
}

variable "environment_vars" {
  type = map
  default = {}
}

variable "memory_size" {
  default = 128
  description = "(Optional) Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
}

variable "timeout" {
  default = 30
  description = "(Optional) The amount of time your Lambda Function has to run in seconds. Defaults to 3."
}

variable "description" {
  default = ""
  description = "(Optional) Description of what your Lambda Function does."
}

variable "performance_mode" {
  description = "(Optional) The performance mode of your file system."
  type        = string
  default     = "generalPurpose"
}

variable "source_file" {
  description = "source of the file to zip"
}

variable "output_file_path" {
  description = "location of the output zip file"
}

variable "archive_type" {
  default = "zip"
  description = "type of file"
}