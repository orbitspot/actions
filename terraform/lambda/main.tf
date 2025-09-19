locals {
  # Import from locals.tf for better organization
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${local.function_name}-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  
  tags = local.common_tags
}

# Basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# VPC execution policy (if VPC is enabled)
resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  count      = var.vpc_config.subnet_ids != null ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Custom IAM policies for Lambda
resource "aws_iam_role_policy" "lambda_custom_policy" {
  count = length(var.iam_policies) > 0 ? 1 : 0
  name  = "${local.function_name}-custom-policy"
  role  = aws_iam_role.lambda_role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = var.iam_policies
  })
}

# Lambda function
resource "aws_lambda_function" "function" {
  function_name = local.function_name
  role         = aws_iam_role.lambda_role.arn
  handler      = var.handler
  runtime      = var.runtime
  timeout      = local.lambda_timeout
  memory_size  = local.lambda_memory
  
  # Code deployment
  dynamic "code" {
    for_each = var.s3_bucket != "" ? [1] : []
    content {
      s3_bucket = var.s3_bucket
      s3_key    = var.s3_key
    }
  }
  
  dynamic "code" {
    for_each = var.s3_bucket == "" ? [1] : []
    content {
      zip_file = var.zip_file != "" ? var.zip_file : "exports.handler = async (event) => { console.log('Hello from Lambda!'); };"
    }
  }
  
  # Environment variables
  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }
  
  # VPC configuration
  dynamic "vpc_config" {
    for_each = var.vpc_config.subnet_ids != null ? [1] : []
    content {
      subnet_ids         = var.vpc_config.subnet_ids
      security_group_ids = var.vpc_config.security_group_ids
    }
  }
  
  # Dead letter queue
  dynamic "dead_letter_config" {
    for_each = var.dead_letter_queue_arn != "" ? [1] : []
    content {
      target_arn = var.dead_letter_queue_arn
    }
  }
  
  # Reserved concurrency
  reserved_concurrent_executions = var.reserved_concurrent_executions
  
  tags = local.common_tags
}

# Lambda function URL (if enabled)
resource "aws_lambda_function_url" "function_url" {
  count              = local.function_url_config.enabled ? 1 : 0
  function_name      = aws_lambda_function.function.function_name
  authorization_type = local.function_url_config.authorization_type
  
  dynamic "cors" {
    for_each = local.function_url_config.cors != null ? [1] : []
    content {
      allow_credentials = local.function_url_config.cors.allow_credentials
      allow_headers     = local.function_url_config.cors.allow_headers
      allow_methods     = local.function_url_config.cors.allow_methods
      allow_origins     = local.function_url_config.cors.allow_origins
      expose_headers    = local.function_url_config.cors.expose_headers
      max_age          = local.function_url_config.cors.max_age
    }
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = local.final_log_retention
  tags              = local.common_tags
}
