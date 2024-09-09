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
    response_templates = map(string)
    response_parameters = map(string)
  })
}
variable "method_response" {
  type = object({
    response_models = map(string)
    response_parameters = map(string)
  })
}
variable "regex_mapping" {
  type = map(string)
  default = {
    "200" = "20[0-35-9]",
    "201" = "201",
    "204" = "204" ,
    "400" = "40[0-25-9]",
    "403" = "403",
    "404" = "404",
    "500" = "500"
  }
}
variable "resource_id" {
  type = string
}

variable "timeout_milliseconds" {
  type = number
  default = 29000
}
