module "cloudwatch_event" {
  source = "git::git@github.com:tomarv2/terraform-aws-cloudwatch-events.git"

  deploy_event_rule   = var.deploy_cloudwatch_event_trigger
  deploy_event_target = var.deploy_cloudwatch_event_trigger

  target_arn = join("", aws_lambda_function.lambda.*.arn)
  #-----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.prjid
  prjid  = var.teamid
}

resource "aws_lambda_permission" "cloudwatch" {
  count = var.deploy_cloudwatch_event_trigger ? 1 : 0

  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = join("", aws_lambda_function.lambda.*.arn)
  principal     = "events.amazonaws.com"
  source_arn    = module.cloudwatch_event.cloudwatch_event_rule_arn
}
