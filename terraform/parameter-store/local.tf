locals {
  variables = jsondecode(file("variables.json"))
  secrets = jsondecode(replace(file("secrets.json"), "/$", "$$"))
}