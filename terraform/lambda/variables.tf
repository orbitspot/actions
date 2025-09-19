# Required variables
variable "branch" {
  description = "Git branch for environment mapping (master, homolog, develop)"
  type        = string
}

variable "repository_name" {
  description = "Name of the repository (used for resource naming)"
  type        = string
}

# Lambda function configuration
variable "function_name" {
  description = "Custom name for the Lambda function (optional)"
  type        = string
  default     = ""
}

variable "handler" {
  description = "Lambda function handler"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "nodejs18.x"
}

variable "timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Lambda memory size in MB"
  type        = number
  default     = 128
}

variable "reserved_concurrent_executions" {
  description = "Amount of reserved concurrent executions for this lambda function"
  type        = number
  default     = -1
}

# Code deployment
variable "s3_bucket" {
  description = "S3 bucket containing the function code"
  type        = string
  default     = ""
}

variable "s3_key" {
  description = "S3 key of the function code"
  type        = string
  default     = ""
}

variable "zip_file" {
  description = "Inline function code (for simple functions)"
  type        = string
  default     = ""
}

# Environment and configuration
variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}

# VPC configuration
variable "vpc_config" {
  description = "VPC configuration for Lambda function"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = {
    subnet_ids         = null
    security_group_ids = null
  }
}

# IAM permissions
variable "iam_policies" {
  description = "Custom IAM policy statements for Lambda execution role"
  type = list(object({
    Effect   = string
    Action   = list(string)
    Resource = list(string)
  }))
  default = []
}

# Dead letter queue
variable "dead_letter_queue_arn" {
  description = "ARN of the dead letter queue"
  type        = string
  default     = ""
}

# Function URL configuration
variable "function_url_enabled" {
  description = "Enable Lambda function URL"
  type        = bool
  default     = false
}

variable "function_url_auth_type" {
  description = "Authorization type for function URL"
  type        = string
  default     = "AWS_IAM"
}

variable "function_url_cors" {
  description = "CORS configuration for function URL (JSON string)"
  type        = string
  default     = "null"
}

# Legacy function_url variable for backward compatibility
variable "function_url" {
  description = "Lambda function URL configuration (legacy, use individual vars)"
  type = object({
    enabled           = bool
    authorization_type = string
    cors = optional(object({
      allow_credentials = bool
      allow_headers     = list(string)
      allow_methods     = list(string)
      allow_origins     = list(string)
      expose_headers    = list(string)
      max_age          = number
    }))
  })
  default = {
    enabled           = false
    authorization_type = "AWS_IAM"
    cors              = null
  }
}

# Logging
variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}

# Trigger configurations
variable "api_gateway_triggers" {
  description = "API Gateway trigger configurations"
  type = list(object({
    api_id      = string
    resource_id = string
    http_method = string
    path        = string
  }))
  default = []
}

variable "s3_triggers" {
  description = "S3 trigger configurations"
  type = list(object({
    bucket_name = string
    events      = list(string)
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  default = []
}

variable "sns_triggers" {
  description = "SNS topic ARNs that should trigger this function"
  type        = list(string)
  default     = []
}

variable "sqs_triggers" {
  description = "SQS trigger configurations"
  type = list(object({
    queue_arn                    = string
    batch_size                   = optional(number, 10)
    maximum_batching_window_in_seconds = optional(number, 0)
    enabled                      = optional(bool, true)
  }))
  default = []
}

variable "dynamodb_triggers" {
  description = "DynamoDB stream trigger configurations"
  type = list(object({
    event_source_arn  = string
    starting_position = string
    batch_size        = optional(number, 100)
    enabled           = optional(bool, true)
  }))
  default = []
}

variable "kinesis_triggers" {
  description = "Kinesis stream trigger configurations"
  type = list(object({
    event_source_arn  = string
    starting_position = string
    batch_size        = optional(number, 100)
    enabled           = optional(bool, true)
  }))
  default = []
}

variable "cloudwatch_event_triggers" {
  description = "CloudWatch Events (EventBridge) trigger configurations"
  type = list(object({
    rule_name         = string
    rule_description  = optional(string, "")
    schedule_expression = optional(string, "")
    event_pattern     = optional(string, "")
    enabled           = optional(bool, true)
  }))
  default = []
}

variable "cloudwatch_log_triggers" {
  description = "CloudWatch Logs trigger configurations"
  type = list(object({
    log_group_name = string
    filter_name    = string
    filter_pattern = string
  }))
  default = []
}

variable "cognito_triggers" {
  description = "Cognito User Pool trigger configurations"
  type = list(object({
    user_pool_id = string
    trigger_name = string # pre_sign_up, post_confirmation, etc.
  }))
  default = []
}

variable "alb_triggers" {
  description = "Application Load Balancer trigger configurations"
  type = list(object({
    target_group_arn = string
    conditions = list(object({
      field  = string
      values = list(string)
    }))
    priority = number
  }))
  default = []
}
