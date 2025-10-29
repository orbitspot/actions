variable "branch" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "hosts" {
  type = object({
    master  = string
    homolog = string
    develop = string
    test    = string
  })
}

variable "ssl" {
  type    = bool
  default = true
}

variable "istio_enabled" {
  type    = bool
  default = true
}

variable "docs" {
  type    = string
  default = "api-json"
}

variable "resource_name" {
  type    = string
  default = null
}

variable "apply_response_script" {
  type    = bool
  default = true
}

variable "api_gateway" {
  type = object({
    master = list(object({
      oauth2 = object({
        parent_id         = string
        custom_authorizer = string
      })
      default = object({
        parent_id         = string
        custom_authorizer = string
      })
      rest_api_id = string
      region      = string
    }))
    homolog = list(object({
      oauth2 = object({
        parent_id         = string
        custom_authorizer = string
      })
      default = object({
        parent_id         = string
        custom_authorizer = string
      })
      rest_api_id = string
      region      = string
    }))
    develop = list(object({
      oauth2 = object({
        parent_id         = string
        custom_authorizer = string
      })
      default = object({
        parent_id         = string
        custom_authorizer = string
      })
      rest_api_id = string
      region      = string
    }))
    test = list(object({
      oauth2 = object({
        parent_id         = string
        custom_authorizer = string
      })
      default = object({
        parent_id         = string
        custom_authorizer = string
      })
      rest_api_id = string
      region      = string
    }))
  })
}
