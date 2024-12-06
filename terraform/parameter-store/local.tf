locals {
  variables = jsondecode(file("variables.json"))
  secrets = jsondecode(file("secrets.json"))
}