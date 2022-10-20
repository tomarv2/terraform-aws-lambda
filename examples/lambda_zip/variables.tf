variable "teamid" {
  description = "Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
  type        = string
  default     = "rumse"
}

variable "prjid" {
  description = "Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
  type        = string
  default     = "demo"
}

variable "region" {
  description = "AWS region to create resources"
  default     = "us-west-2"
  type        = string
}

variable "role_arn" {
  description = "Lambda role"
  default     = "arn:aws:iam::123456789012:role/demo-role"
}