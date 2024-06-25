output "branch" {
  value = var.branch
}

output "current_api_gateway" {
  value = local.current_api_gateway
}

output "repository_name" {
  value = var.repository_name
}

output "hosts" {
  value = var.hosts
}

output "current_host" {
  value = local.current_host
}

output "uri" {
  value = local.uri
}

output "path" {
  value = local.api_gateway_resource
}

#output "module" {
#  value = module.api-gateway
#}