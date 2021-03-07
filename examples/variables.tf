# Additional documentation: https://www.terraform.io/docs/configuration/variables.html
variable "teamid" {
  description = "(Required) Name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
}

variable "prjid" {
  description = "(Required) Name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
}

variable "aws_region" {
  default = "us-west-2"
}
