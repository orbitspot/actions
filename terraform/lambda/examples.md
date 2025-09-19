# Lambda Module Usage Examples

This module supports creating AWS Lambda functions with various trigger types. Below are examples for different use cases.

## Basic Lambda Function

```hcl
module "basic_lambda" {
  source = "./terraform/lambda"
  
  branch          = "develop"
  repository_name = "my-service"
  handler         = "index.handler"
  runtime         = "nodejs18.x"
  timeout         = 30
  memory_size     = 128
  
  environment_variables = {
    NODE_ENV = "development"
    LOG_LEVEL = "debug"
  }
  
  tags = {
    Team = "backend"
    Cost = "development"
  }
}
```

## Lambda with S3 Trigger

```hcl
module "s3_processor_lambda" {
  source = "./terraform/lambda"
  
  branch          = "develop"
  repository_name = "file-processor"
  handler         = "src/s3Handler.process"
  runtime         = "python3.9"
  timeout         = 300
  memory_size     = 512
  
  s3_triggers = [
    {
      bucket_name   = "my-upload-bucket"
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "uploads/"
      filter_suffix = ".jpg"
    },
    {
      bucket_name   = "my-upload-bucket"
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "documents/"
      filter_suffix = ".pdf"
    }
  ]
  
  iam_policies = [
    {
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ]
      Resource = [
        "arn:aws:s3:::my-upload-bucket/*",
        "arn:aws:s3:::my-processed-bucket/*"
      ]
    }
  ]
}
```

## Lambda with SQS and DynamoDB Triggers

```hcl
module "queue_processor_lambda" {
  source = "./terraform/lambda"
  
  branch          = "develop"
  repository_name = "queue-processor"
  handler         = "index.processMessages"
  runtime         = "nodejs18.x"
  timeout         = 900
  memory_size     = 1024
  
  sqs_triggers = [
    {
      queue_arn                          = "arn:aws:sqs:us-east-1:123456789012:high-priority-queue"
      batch_size                         = 5
      maximum_batching_window_in_seconds = 10
      enabled                           = true
    },
    {
      queue_arn                          = "arn:aws:sqs:us-east-1:123456789012:low-priority-queue"
      batch_size                         = 10
      maximum_batching_window_in_seconds = 30
      enabled                           = true
    }
  ]
  
  dynamodb_triggers = [
    {
      event_source_arn  = "arn:aws:dynamodb:us-east-1:123456789012:table/Users/stream/2024-01-01T00:00:00.000"
      starting_position = "LATEST"
      batch_size        = 100
      enabled           = true
    }
  ]
  
  iam_policies = [
    {
      Effect = "Allow"
      Action = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ]
      Resource = [
        "arn:aws:sqs:us-east-1:123456789012:high-priority-queue",
        "arn:aws:sqs:us-east-1:123456789012:low-priority-queue"
      ]
    },
    {
      Effect = "Allow"
      Action = [
        "dynamodb:DescribeStream",
        "dynamodb:GetRecords",
        "dynamodb:GetShardIterator",
        "dynamodb:ListStreams"
      ]
      Resource = [
        "arn:aws:dynamodb:us-east-1:123456789012:table/Users/stream/*"
      ]
    }
  ]
}
```

## Scheduled Lambda (Cron Job)

```hcl
module "scheduled_lambda" {
  source = "./terraform/lambda"
  
  branch          = "develop"
  repository_name = "daily-report"
  handler         = "handlers/scheduler.dailyReport"
  runtime         = "python3.9"
  timeout         = 600
  memory_size     = 256
  
  cloudwatch_event_triggers = [
    {
      rule_name           = "daily-report"
      rule_description    = "Trigger daily report generation"
      schedule_expression = "cron(0 8 * * ? *)"  # Every day at 8 AM UTC
      enabled            = true
    },
    {
      rule_name           = "weekly-cleanup"
      rule_description    = "Weekly cleanup task"
      schedule_expression = "cron(0 2 ? * SUN *)"  # Every Sunday at 2 AM UTC
      enabled            = true
    }
  ]
  
  iam_policies = [
    {
      Effect = "Allow"
      Action = [
        "ses:SendEmail",
        "ses:SendRawEmail"
      ]
      Resource = ["*"]
    }
  ]
}
```

## Lambda with Function URL (HTTP endpoint)

```hcl
module "api_lambda" {
  source = "./terraform/lambda"
  
  branch          = "develop"
  repository_name = "webhook-handler"
  handler         = "api/webhook.handle"
  runtime         = "nodejs18.x"
  timeout         = 30
  memory_size     = 256
  
  function_url = {
    enabled           = true
    authorization_type = "NONE"
    cors = {
      allow_credentials = false
      allow_headers     = ["content-type", "x-custom-header"]
      allow_methods     = ["GET", "POST"]
      allow_origins     = ["https://example.com", "https://app.example.com"]
      expose_headers    = ["x-response-id"]
      max_age          = 86400
    }
  }
  
  environment_variables = {
    WEBHOOK_SECRET = "your-secret-here"
    API_VERSION   = "v1"
  }
}
```

## Lambda with VPC Configuration

```hcl
module "vpc_lambda" {
  source = "./terraform/lambda"
  
  branch          = "develop"
  repository_name = "database-worker"
  handler         = "db/worker.process"
  runtime         = "python3.9"
  timeout         = 300
  memory_size     = 512
  
  vpc_config = {
    subnet_ids         = ["subnet-12345", "subnet-67890"]
    security_group_ids = ["sg-lambda-access"]
  }
  
  environment_variables = {
    DB_HOST = "database.internal.com"
    DB_PORT = "5432"
  }
  
  iam_policies = [
    {
      Effect = "Allow"
      Action = [
        "rds:DescribeDBInstances",
        "rds-db:connect"
      ]
      Resource = ["*"]
    }
  ]
}
```

## Lambda with Multiple Trigger Types

```hcl
module "multi_trigger_lambda" {
  source = "./terraform/lambda"
  
  branch          = "develop"
  repository_name = "event-processor"
  handler         = "src/processor.handleEvent"
  runtime         = "python3.9"
  timeout         = 300
  memory_size     = 1024
  
  # SNS triggers
  sns_triggers = [
    "arn:aws:sns:us-east-1:123456789012:user-events",
    "arn:aws:sns:us-east-1:123456789012:system-alerts"
  ]
  
  # S3 triggers
  s3_triggers = [
    {
      bucket_name   = "event-logs-bucket"
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "logs/"
    }
  ]
  
  # Scheduled triggers
  cloudwatch_event_triggers = [
    {
      rule_name           = "hourly-process"
      rule_description    = "Process events every hour"
      schedule_expression = "cron(0 * * * ? *)"
      enabled            = true
    }
  ]
  
  # CloudWatch Logs triggers
  cloudwatch_log_triggers = [
    {
      log_group_name = "/aws/apigateway/access-logs"
      filter_name    = "error-filter"
      filter_pattern = "[timestamp, request_id, ip, user, timestamp, method, path, protocol, status_code=5*, size, referer, user_agent]"
    }
  ]
  
  # Dead letter queue
  dead_letter_queue_arn = "arn:aws:sqs:us-east-1:123456789012:lambda-dlq"
  
  iam_policies = [
    {
      Effect = "Allow"
      Action = [
        "sns:Publish",
        "s3:GetObject",
        "sqs:SendMessage",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = ["*"]
    }
  ]
}
```

## Environment-Specific Configuration

```hcl
# Use locals for environment-specific settings
locals {
  environment_config = {
    develop = {
      memory_size = 128
      timeout     = 30
      log_retention = 7
    }
    homolog = {
      memory_size = 256
      timeout     = 60
      log_retention = 14
    }
    master = {
      memory_size = 512
      timeout     = 300
      log_retention = 30
    }
  }
  
  current_config = local.environment_config[var.branch]
}

module "environment_aware_lambda" {
  source = "./terraform/lambda"
  
  branch              = var.branch
  repository_name     = var.repository_name
  memory_size         = local.current_config.memory_size
  timeout             = local.current_config.timeout
  log_retention_days  = local.current_config.log_retention
  
  environment_variables = {
    ENVIRONMENT = var.branch
    DEBUG       = var.branch == "develop" ? "true" : "false"
  }
}
```

## Output Usage

```hcl
# Access Lambda outputs
output "lambda_function_url" {
  value = module.api_lambda.function_url
}

output "lambda_function_arn" {
  value = module.basic_lambda.function_arn
}

# Use outputs in other resources
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = "POST"
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = module.api_lambda.function_invoke_arn
}
```
