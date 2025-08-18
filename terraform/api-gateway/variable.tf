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
  })
  default = {
    develop = [
      {
        default : {
          parent_id : "h0ebgzn072",
          custom_authorizer : "wj7i3i",
        },
        oauth2 : {
          parent_id : "gqh1ab",
          custom_authorizer : "dhz1f6",
        },
        rest_api_id : "d4c33alv35",
        region : "us-east-1"
      },
      {
        default : {
          parent_id : "hx5807dj99",
          custom_authorizer : "5mq3cv",
        },
        oauth2 : {
          parent_id : "dc8sdh",
          custom_authorizer : "rive7o",
        },
        rest_api_id : "vvu27u8aga",
        region : "us-east-1"
    }],
    homolog = [],
    master  = []
  }
}
