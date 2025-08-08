locals {
  api_data = {
    for index, obj in local.current_api_gateway : obj.rest_api_id => obj
  }
}

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

module "api_gateway" {
  for_each = local.api_data
  source   = "./modules/default"
  api_data = {
    parent_id         = each.value["parent_id"]
    rest_api_id       = each.value["rest_api_id"]
    custom_authorizer = each.value["custom_authorizer"]
  }
  # api_data              = each.value
  load_balancer         = local.uri
  path                  = local.api_gateway_resource
  istio_enabled         = var.istio_enabled
  docs                  = var.docs
  resource_name         = var.resource_name
  apply_response_script = var.apply_response_script
}

module "internal_docs" {
  for_each = local.api_data
  source   = "./modules/internal-docs"
  # api_data = {
  #   parent_id         = each.value["parent_id"]
  #   rest_api_id       = each.value["rest_api_id"]
  #   custom_authorizer = each.value["custom_authorizer"]
  # }
  api_data      = each.value
  load_balancer = local.uri
  path          = local.api_gateway_resource
  docs          = var.docs
}
