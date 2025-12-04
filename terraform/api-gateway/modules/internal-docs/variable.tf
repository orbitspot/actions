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
    vpc_id = string
  })
}

variable "region" {
  type = string
}