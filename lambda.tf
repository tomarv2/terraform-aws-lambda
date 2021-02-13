module "lambda" {
  source = "./module"

  email                                 = var.email
  teamid                                = var.teamid
  prjid                                 = var.prjid
  profile_to_use                        = var.profile_to_use
  account_id                            = var.account_id
  aws_region                            = var.aws_region
  #-------------------------------------------------------------------------
  # CUSTOMIZE
  #--------------------------------------------------------------------------
  role                                  = var.role
  description                           = var.description
  environment_vars                      = var.environment_vars
  handler                               = var.handler
  memory_size                           = var.memory_size
  runtime                               = var.runtime
  timeout                               = var.timeout
  output_file_path                      = var.output_file_path
  source_file                           = var.source_file
}

