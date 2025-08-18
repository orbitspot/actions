locals {
  api_data = {
    for index, obj in local.current_api_gateway : obj.rest_api_id => obj
  }

  api_oauth_data = {
    for index, obj in local.current_api_gateway_oauth : obj.rest_api_id => obj
  }
}

module "default_routes" {
  source                = "./modules/default"
  for_each              = local.api_data
  api_data              = each.value
  load_balancer         = local.uri
  path                  = local.api_gateway_resource
  istio_enabled         = var.istio_enabled
  apply_response_script = var.apply_response_script
}

module "oauth_routes" {
  source                = "./modules/default"
  for_each              = local.api_oauth_data
  api_data              = each.value
  load_balancer         = local.uri
  path                  = local.api_gateway_resource
  istio_enabled         = var.istio_enabled
  apply_response_script = var.apply_response_script
}

module "internal_docs" {
  source        = "./modules/internal-docs"
  for_each      = local.api_data
  api_data      = each.value
  load_balancer = local.uri
  path          = local.api_gateway_resource
  docs          = var.docs
}
