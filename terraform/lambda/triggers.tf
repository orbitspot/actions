# API Gateway triggers
resource "aws_lambda_permission" "api_gateway" {
  count         = length(var.api_gateway_triggers)
  statement_id  = "AllowExecutionFromAPIGateway-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.api_gateway_triggers[count.index].api_id}/*/${var.api_gateway_triggers[count.index].http_method}${var.api_gateway_triggers[count.index].path}"
}

# S3 triggers
resource "aws_s3_bucket_notification" "s3_triggers" {
  count  = length(var.s3_triggers) > 0 ? 1 : 0
  bucket = var.s3_triggers[0].bucket_name

  dynamic "lambda_function" {
    for_each = var.s3_triggers
    content {
      lambda_function_arn = aws_lambda_function.function.arn
      events              = lambda_function.value.events
      filter_prefix       = lambda_function.value.filter_prefix
      filter_suffix       = lambda_function.value.filter_suffix
    }
  }

  depends_on = [aws_lambda_permission.s3]
}

resource "aws_lambda_permission" "s3" {
  count         = length(var.s3_triggers)
  statement_id  = "AllowExecutionFromS3Bucket-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.s3_triggers[count.index].bucket_name}"
}

# SNS triggers
resource "aws_sns_topic_subscription" "sns_triggers" {
  count     = length(var.sns_triggers)
  topic_arn = var.sns_triggers[count.index]
  protocol  = "lambda"
  endpoint  = aws_lambda_function.function.arn
}

resource "aws_lambda_permission" "sns" {
  count         = length(var.sns_triggers)
  statement_id  = "AllowExecutionFromSNS-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_triggers[count.index]
}

# SQS triggers
resource "aws_lambda_event_source_mapping" "sqs_triggers" {
  count            = length(var.sqs_triggers)
  event_source_arn = var.sqs_triggers[count.index].queue_arn
  function_name    = aws_lambda_function.function.arn
  batch_size       = var.sqs_triggers[count.index].batch_size
  maximum_batching_window_in_seconds = var.sqs_triggers[count.index].maximum_batching_window_in_seconds
  enabled          = var.sqs_triggers[count.index].enabled
}

# DynamoDB triggers
resource "aws_lambda_event_source_mapping" "dynamodb_triggers" {
  count             = length(var.dynamodb_triggers)
  event_source_arn  = var.dynamodb_triggers[count.index].event_source_arn
  function_name     = aws_lambda_function.function.arn
  starting_position = var.dynamodb_triggers[count.index].starting_position
  batch_size        = var.dynamodb_triggers[count.index].batch_size
  enabled           = var.dynamodb_triggers[count.index].enabled
}

# Kinesis triggers
resource "aws_lambda_event_source_mapping" "kinesis_triggers" {
  count             = length(var.kinesis_triggers)
  event_source_arn  = var.kinesis_triggers[count.index].event_source_arn
  function_name     = aws_lambda_function.function.arn
  starting_position = var.kinesis_triggers[count.index].starting_position
  batch_size        = var.kinesis_triggers[count.index].batch_size
  enabled           = var.kinesis_triggers[count.index].enabled
}

# CloudWatch Events (EventBridge) triggers
resource "aws_cloudwatch_event_rule" "event_triggers" {
  count               = length(var.cloudwatch_event_triggers)
  name                = "${local.function_name}-${var.cloudwatch_event_triggers[count.index].rule_name}"
  description         = var.cloudwatch_event_triggers[count.index].rule_description
  schedule_expression = var.cloudwatch_event_triggers[count.index].schedule_expression
  event_pattern       = var.cloudwatch_event_triggers[count.index].event_pattern
  state              = var.cloudwatch_event_triggers[count.index].enabled ? "ENABLED" : "DISABLED"
  
  tags = local.common_tags
}

resource "aws_cloudwatch_event_target" "event_targets" {
  count     = length(var.cloudwatch_event_triggers)
  rule      = aws_cloudwatch_event_rule.event_triggers[count.index].name
  target_id = "LambdaTarget-${count.index}"
  arn       = aws_lambda_function.function.arn
}

resource "aws_lambda_permission" "cloudwatch_events" {
  count         = length(var.cloudwatch_event_triggers)
  statement_id  = "AllowExecutionFromCloudWatch-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_triggers[count.index].arn
}

# CloudWatch Logs triggers
resource "aws_cloudwatch_log_subscription_filter" "log_triggers" {
  count           = length(var.cloudwatch_log_triggers)
  name            = "${local.function_name}-${var.cloudwatch_log_triggers[count.index].filter_name}"
  log_group_name  = var.cloudwatch_log_triggers[count.index].log_group_name
  filter_pattern  = var.cloudwatch_log_triggers[count.index].filter_pattern
  destination_arn = aws_lambda_function.function.arn
}

resource "aws_lambda_permission" "cloudwatch_logs" {
  count         = length(var.cloudwatch_log_triggers)
  statement_id  = "AllowExecutionFromCloudWatchLogs-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "logs.${data.aws_region.current.name}.amazonaws.com"
  source_arn    = "${var.cloudwatch_log_triggers[count.index].log_group_name}:*"
}

# Cognito triggers (handled via Cognito User Pool configuration)
# Note: This requires the Cognito User Pool to be configured to use this Lambda function
# The actual trigger configuration is done on the Cognito side

# ALB triggers
resource "aws_lb_target_group_attachment" "alb_triggers" {
  count            = length(var.alb_triggers)
  target_group_arn = var.alb_triggers[count.index].target_group_arn
  target_id        = aws_lambda_function.function.arn
  depends_on       = [aws_lambda_permission.alb]
}

resource "aws_lambda_permission" "alb" {
  count         = length(var.alb_triggers)
  statement_id  = "AllowExecutionFromALB-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = var.alb_triggers[count.index].target_group_arn
}

# Data sources for region and account ID
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
