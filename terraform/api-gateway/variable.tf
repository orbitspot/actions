variable "branch" {
  type = string
}

variable "repository_name" {
  type = string
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