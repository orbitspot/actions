locals {
  variables = jsondecode(file("variables.json"))
  secrets = replace(jsondecode(file("secrets.json")), "/$", "$$")
}