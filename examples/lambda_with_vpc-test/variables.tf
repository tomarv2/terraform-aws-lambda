variable "teamid" {
  description = "(Required) name of the team/group e.g. devops, dataengineering. Should not be changed after running 'tf apply'"
  type        = string
  default = "rumse"
}

variable "prjid" {
  description = "(Required) name of the project/stack e.g: mystack, nifieks, demoaci. Should not be changed after running 'tf apply'"
  type        = string
  default = "demo"
}