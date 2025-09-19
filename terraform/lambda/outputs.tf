output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.function.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.function.arn
}

output "function_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.function.invoke_arn
}

output "function_url" {
  description = "Function URL (if enabled)"
  value       = length(aws_lambda_function_url.function_url) > 0 ? aws_lambda_function_url.function_url[0].function_url : null
}

output "function_role_arn" {
  description = "ARN of the IAM role used by the Lambda function"
  value       = aws_iam_role.lambda_role.arn
}

output "function_role_name" {
  description = "Name of the IAM role used by the Lambda function"
  value       = aws_iam_role.lambda_role.name
}

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_logs.arn
}

# Trigger outputs
output "cloudwatch_event_rules" {
  description = "CloudWatch event rules created for triggers"
  value = {
    for idx, rule in aws_cloudwatch_event_rule.event_triggers : 
    var.cloudwatch_event_triggers[idx].rule_name => {
      name = rule.name
      arn  = rule.arn
    }
  }
}

output "sqs_event_source_mappings" {
  description = "SQS event source mappings"
  value = {
    for idx, mapping in aws_lambda_event_source_mapping.sqs_triggers :
    idx => {
      uuid         = mapping.uuid
      function_name = mapping.function_name
      event_source_arn = mapping.event_source_arn
    }
  }
}

output "dynamodb_event_source_mappings" {
  description = "DynamoDB event source mappings"
  value = {
    for idx, mapping in aws_lambda_event_source_mapping.dynamodb_triggers :
    idx => {
      uuid         = mapping.uuid
      function_name = mapping.function_name
      event_source_arn = mapping.event_source_arn
    }
  }
}

output "kinesis_event_source_mappings" {
  description = "Kinesis event source mappings"
  value = {
    for idx, mapping in aws_lambda_event_source_mapping.kinesis_triggers :
    idx => {
      uuid         = mapping.uuid
      function_name = mapping.function_name
      event_source_arn = mapping.event_source_arn
    }
  }
}
