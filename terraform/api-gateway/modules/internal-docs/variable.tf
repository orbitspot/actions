variable "path" {
  type = string
}

variable "load_balancer" {
  type = string
}

variable "docs" {
  type = string
}

variable "api_data" {
  type = object({
    parent_id         = string
    rest_api_id       = string
    custom_authorizer = string
  })
}
