# Local values for better organization and reusability
locals {
  # Environment-based configuration
  current_environment = var.branch
  function_name = var.function_name != "" ? var.function_name : "${var.repository_name}-${var.branch}"
  
  # Lambda configuration
  lambda_timeout = var.timeout > 0 ? var.timeout : 30
  lambda_memory = var.memory_size > 0 ? var.memory_size : 128
  
  # Common tags applied to all resources
  common_tags = merge(var.tags, {
    Environment = local.current_environment
    Repository = var.repository_name
    ManagedBy = "terraform"
    Module = "lambda"
    Branch = var.branch
  })
  
  # Environment-specific defaults
  environment_defaults = {
    develop = {
      log_retention = 7
      memory_min    = 128
    }
    homolog = {
      log_retention = 14
      memory_min    = 256
    }
    master = {
      log_retention = 30
      memory_min    = 512
    }
  }
  
  # Get current environment defaults
  current_defaults = lookup(local.environment_defaults, var.branch, local.environment_defaults.develop)
  
  # Final log retention (use variable if set, otherwise environment default)
  final_log_retention = var.log_retention_days > 0 ? var.log_retention_days : local.current_defaults.log_retention
  
  # Function URL configuration (merge individual vars with legacy object)
  function_url_config = {
    enabled           = var.function_url_enabled || var.function_url.enabled
    authorization_type = var.function_url_auth_type != "AWS_IAM" ? var.function_url_auth_type : var.function_url.authorization_type
    cors              = var.function_url_cors != "null" ? jsondecode(var.function_url_cors) : var.function_url.cors
  }
}
