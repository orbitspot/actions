locals {
  api_data = {
    for index, obj in var.api_data : obj.rest_api_id => obj
  }
}

module "default" {
  source = "./resources"
  api_data = {
    parent_id         = var.api_data.parent_id
    rest_api_id       = var.api_data.rest_api_id
    custom_authorizer = var.api_data.custom_authorizer
  }
  load_balancer         = var.load_balancer
  path                  = var.path
  istio_enabled         = var.istio_enabled
  apply_response_script = var.apply_response_script
}

module "oauth2" {
  source = "./resources"
  api_data = {
    # Trocar parent
    parent_id         = var.api_data.parent_id
    rest_api_id       = var.api_data.rest_api_id
    custom_authorizer = var.api_data.custom_authorizer_oauth2
  }
  load_balancer         = var.load_balancer
  path                  = var.path
  istio_enabled         = var.istio_enabled
  apply_response_script = var.apply_response_script
}
