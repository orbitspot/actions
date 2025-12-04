variable "rest_api_id" {
  type = string
}

variable "http_method" {
  type = string
}

variable "method" {
  type = object({
    authorization = string
    authorizer_id = string
    request_method_api_key_required = bool
    request_parameters = map(string)
  })
}
variable "integration" {
  type = object({
    uri = string
    type = string
    integration_http_method = string
    request_parameters = map(string)
    request_templates = map(string)
  })
}
variable "integration_response" {
  type = object({
    status_code = map(string)
    response_templates = map(string)
    response_parameters = map(string)
  })
}
variable "method_response" {
  type = object({
    status_code = map(string)
    response_models = map(string)
    response_parameters = map(string)
  })
}

variable "resource_id" {
  type = string
}

variable "timeout_milliseconds" {
  type = number
  default = 29000
}

variable "vpc_id" {
  type = string
  default = ""
}

variable "region" {
  type = string
  default = "us-east-1"
}
