# AWS Lambda Terraform Module

A comprehensive Terraform module for creating AWS Lambda functions with support for multiple trigger types and configurations.

## Features

- **Multiple Trigger Types**: API Gateway, S3, SNS, SQS, DynamoDB, Kinesis, CloudWatch Events, CloudWatch Logs, Cognito, ALB
- **Environment-aware**: Branch-based configuration (develop/homolog/master)
- **VPC Support**: Configure Lambda to run within a VPC
- **Function URLs**: HTTP endpoints for Lambda functions
- **IAM Integration**: Flexible IAM policy configuration
- **Monitoring**: CloudWatch Logs integration with configurable retention
- **Dead Letter Queues**: Error handling configuration
- **CORS Support**: For Function URLs

## Quick Start

```hcl
module "my_lambda" {
  source = "./terraform/lambda"
  
  branch          = "develop"
  repository_name = "my-service"
  handler         = "index.handler"
  runtime         = "nodejs18.x"
  
  environment_variables = {
    NODE_ENV = "development"
  }
}
```

## Supported Trigger Types

### API Gateway
```hcl
api_gateway_triggers = [
  {
    api_id      = "your-api-id"
    resource_id = "your-resource-id"
    http_method = "POST"
    path        = "/webhook"
  }
]
```

### S3 Events
```hcl
s3_triggers = [
  {
    bucket_name   = "my-bucket"
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "uploads/"
    filter_suffix = ".jpg"
  }
]
```

### SQS Queues
```hcl
sqs_triggers = [
  {
    queue_arn                          = "arn:aws:sqs:region:account:queue-name"
    batch_size                         = 10
    maximum_batching_window_in_seconds = 5
    enabled                           = true
  }
]
```

### Scheduled Events (Cron)
```hcl
cloudwatch_event_triggers = [
  {
    rule_name           = "daily-task"
    schedule_expression = "cron(0 8 * * ? *)"  # Daily at 8 AM UTC
    enabled            = true
  }
]
```

### DynamoDB Streams
```hcl
dynamodb_triggers = [
  {
    event_source_arn  = "arn:aws:dynamodb:region:account:table/Table/stream/timestamp"
    starting_position = "LATEST"
    batch_size        = 100
  }
]
```

### SNS Topics
```hcl
sns_triggers = [
  "arn:aws:sns:region:account:topic-name"
]
```

## Environment Configuration

The module follows the OrbitSpot pattern of environment-based configuration:

- `develop` - Development environment
- `homolog` - Staging environment  
- `master` - Production environment

## File Structure

```
terraform/lambda/
├── main.tf           # Main Lambda function and IAM configuration
├── triggers.tf       # All trigger type configurations
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── provider.tf       # AWS provider configuration
├── versions.tf       # Terraform and provider versions
├── backend.tf        # S3 backend configuration
├── examples.md       # Usage examples
└── README.md         # This file
```

## Requirements

- Terraform >= 1.0
- AWS Provider >= 4.58

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| branch | Git branch for environment mapping | string | n/a | yes |
| repository_name | Repository name for resource naming | string | n/a | yes |
| function_name | Custom Lambda function name | string | "" | no |
| handler | Lambda function handler | string | "index.handler" | no |
| runtime | Lambda runtime | string | "nodejs18.x" | no |
| timeout | Function timeout in seconds | number | 30 | no |
| memory_size | Memory allocation in MB | number | 128 | no |
| environment_variables | Environment variables | map(string) | {} | no |
| vpc_config | VPC configuration | object | null | no |
| iam_policies | Custom IAM policies | list(object) | [] | no |
| *_triggers | Various trigger configurations | list(object) | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| function_name | Lambda function name |
| function_arn | Lambda function ARN |
| function_invoke_arn | Lambda invoke ARN |
| function_url | Function URL (if enabled) |
| function_role_arn | IAM role ARN |
| log_group_name | CloudWatch log group name |

## IAM Permissions

The module creates a Lambda execution role with:
- Basic execution permissions (`AWSLambdaBasicExecutionRole`)
- VPC permissions (if VPC is configured)
- Custom policies (as specified in `iam_policies`)

## Best Practices

1. **Environment Variables**: Use for configuration, avoid secrets
2. **VPC Configuration**: Only when needed (adds cold start latency)
3. **Memory Sizing**: Profile your function to optimize cost/performance
4. **Timeout**: Set appropriately to avoid unnecessary costs
5. **Dead Letter Queues**: Use for critical functions
6. **Monitoring**: Enable CloudWatch insights for production functions

## Examples

See `examples.md` for comprehensive usage examples including:
- Basic Lambda functions
- S3 file processing
- Queue processing with SQS/DynamoDB
- Scheduled tasks (cron jobs)
- HTTP endpoints with Function URLs
- VPC-enabled functions
- Multi-trigger configurations

## Integration with OrbitSpot Actions

This module integrates with the OrbitSpot actions ecosystem:
- Uses the same branch-environment mapping pattern
- Compatible with Parameter Store module for configuration
- Follows the same tagging and naming conventions
- Uses S3 backend for state management
