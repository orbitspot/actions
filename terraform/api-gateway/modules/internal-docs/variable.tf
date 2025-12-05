variable "path" {
  type = string
}

variable "uri" {
  type = string
}

variable "docs" {
  type = string
}

variable "api_data" {
  type = object({
    parent_id   = string
    rest_api_id = string
  })
}

variable "region" {
  type = string
}
