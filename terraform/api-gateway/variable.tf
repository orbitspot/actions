variable "branch" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "hosts" {
  type = object({
    master = string
    homolog = string
    develop = string
  })
}

variable "api_gateway" {
  type = object({
    master = list(object({
      parent_id = string
      rest_api_id = string
      custom_authorizer = string
      region = string
    }))
    homolog = list(object({
      parent_id = string
      rest_api_id = string
      custom_authorizer = string
      region = string
    }))
    develop = list(object({
      parent_id = string
      rest_api_id = string
      custom_authorizer = string
      region = string
    }))
  })
}

variable "ssl" {
  type = bool
  default = true
}

variable "istio_enabled" {
  type = bool
  default = true
}

variable "docs" {
  type = string
  default = "api-json"
}

variable "resource_name" {
  type = string
  default = null
}