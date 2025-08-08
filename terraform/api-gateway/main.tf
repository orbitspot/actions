locals {
  api_data = {
    for index, obj in local.current_api_gateway : obj.rest_api_id => obj
  }
}

module "api_gateway" {
  for_each              = local.api_data
  source                = "./modules/default"
  api_data              = each.value
  load_balancer         = local.uri
  path                  = local.api_gateway_resource
  istio_enabled         = var.istio_enabled
  apply_response_script = var.apply_response_script
}

module "internal_docs" {
  for_each      = local.api_data
  source        = "./modules/internal-docs"
  api_data      = each.value
  load_balancer = local.uri
  path          = local.api_gateway_resource
  docs          = var.docs
}
