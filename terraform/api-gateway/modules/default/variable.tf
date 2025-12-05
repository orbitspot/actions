variable "api_data" {
  type = object({
    parent_id         = string
    rest_api_id       = string
    custom_authorizer = string
    vpc_id            = string
    load_balancer     = string
  })
}

variable "path" {
  type = string
}

variable "uri" {
  type = string
}

variable "istio_enabled" {
  type = bool
}

variable "apply_response_script" {
  type = bool
}

variable "region" {
  type = string
}
