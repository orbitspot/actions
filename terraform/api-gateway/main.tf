locals {
  api_data = {
    for index, obj in local.current_api_gateway : index.rest_api_id => obj
  }
}

# module "api-gateway-first" {
#   source                = "./modules/default"
#   api_data              = local.current_api_gateway[0]
#   load_balancer         = local.uri
#   path                  = local.api_gateway_resource
#   istio_enabled         = var.istio_enabled
#   docs                  = var.docs
#   resource_name         = var.resource_name
#   apply_response_script = var.apply_response_script
# }

# module "api-gateway-second" {
#   source                = "./modules/default"
#   api_data              = local.current_api_gateway[1]
#   load_balancer         = local.uri
#   path                  = local.api_gateway_resource
#   istio_enabled         = var.istio_enabled
#   docs                  = var.docs
#   resource_name         = var.resource_name
#   apply_response_script = var.apply_response_script
# }

# module "api-gateway-oauth2-second" {
#   source = "./modules/default"
#   api_data = {
#     parent_id         = "gqh1ab"
#     rest_api_id       = "d4c33alv35"
#     custom_authorizer = "dhz1f6"
#   }
#   load_balancer         = local.uri
#   path                  = local.api_gateway_resource
#   istio_enabled         = var.istio_enabled
#   docs                  = var.docs
#   resource_name         = var.resource_name
#   apply_response_script = var.apply_response_script
# }

module "api-gateway" {
  for_each = local.current_api_gateway
  source   = "./modules/default"
  api_data = {
    parent_id         = each.parent_id
    rest_api_id       = each.rest_api_id
    custom_authorizer = each.custom_authorizer
  }
  load_balancer         = local.uri
  path                  = local.api_gateway_resource
  istio_enabled         = var.istio_enabled
  docs                  = var.docs
  resource_name         = var.resource_name
  apply_response_script = var.apply_response_script
}
