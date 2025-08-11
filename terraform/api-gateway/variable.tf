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

variable "apply_response_script" {
  type = bool
  default = true
}

variable "api_gateway_oauth2" {
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
  # TODO: Remove
  default = {
    develop = [ 
      {
       parent_id: "gqh1ab",
        rest_api_id: "d4c33alv35",
        custom_authorizer: "dhz1f6",
        region: "us-east-1"
    },
    {
       parent_id: "dc8sdh",
        rest_api_id: "vvu27u8aga",
        custom_authorizer: "rive7o",
        region: "us-east-1"
    },
     ],
     homolog = [ ],
     master = [ ]
  }
}
