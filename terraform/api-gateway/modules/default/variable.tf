variable "api_data" {
  type = object({
    parent_id = string
    rest_api_id = string
    custom_authorizer = string
  })
}

variable "path" {
  type = string
}

variable "load_balancer" {
  type = string
}

variable "istio_enabled" {
  type = bool
}

variable "docs" {
  type = string
}

variable "resource_name" {
  type = string
}

variable "apply_response_script" {
  type = bool
}