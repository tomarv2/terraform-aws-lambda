module "cloudwatch_event" {
  source = "git::git@github.com:tomarv2/terraform-aws-cloudwatch-event.git?ref=v0.0.5"

  count = length(var.cloudwatch_event)

  name         = lookup(var.cloudwatch_event[count.index], "name", null)
  description  = lookup(var.cloudwatch_event[count.index], "description", null)
  custom_input = lookup(var.cloudwatch_event[count.index], "custom_input", null)
  suffix       = lookup(var.cloudwatch_event[count.index], "suffix", null)
  schedule     = lookup(var.cloudwatch_event[count.index], "schedule", null)

  deploy_event_rule   = var.deploy_cloudwatch_event_trigger
  deploy_event_target = var.deploy_cloudwatch_event_trigger

  target_arn = join("", aws_lambda_function.lambda.*.arn)
  #-----------------------------------------------
  # Note: Do not change teamid and prjid once set.
  teamid = var.teamid
  prjid  = var.prjid
}

resource "aws_lambda_permission" "cloudwatch" {
  count = length(var.cloudwatch_event)

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = module.cloudwatch_event[count.index].cloudwatch_event_rule_arn
}
