locals {
  api_data = {
    for index, obj in local.current_api_gateway : obj.rest_api_id => obj
  }
}

module "default_routes" {
  source   = "./modules/default"
  for_each = local.api_data
  api_data = {
    rest_api_id       = each.value["rest_api_id"]
    parent_id         = each.value["default"].parent_id
    custom_authorizer = each.value["default"].custom_authorizer
  }
  vpc                   = each.value["vpc"]
  uri                   = local.uri
  path                  = local.api_gateway_resource
  istio_enabled         = var.istio_enabled
  apply_response_script = var.apply_response_script
  region                = each.value["region"]
}

module "oauth_routes" {
  source   = "./modules/default"
  for_each = local.api_data
  api_data = {
    rest_api_id       = each.value["rest_api_id"]
    parent_id         = each.value["oauth2"].parent_id
    custom_authorizer = each.value["oauth2"].custom_authorizer
  }
  vpc                   = each.value["vpc"]
  uri                   = local.uri
  path                  = local.api_gateway_resource
  istio_enabled         = var.istio_enabled
  apply_response_script = var.apply_response_script
  region                = each.value["region"]
}

module "internal_docs" {
  source   = "./modules/internal-docs"
  for_each = local.api_data
  api_data = {
    rest_api_id = each.value["rest_api_id"]
    parent_id   = each.value["default"].parent_id
  }
  vpc    = each.value["vpc"]
  uri    = local.uri
  path   = local.api_gateway_resource
  docs   = var.docs
  region = each.value["region"]
}
