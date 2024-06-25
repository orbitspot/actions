locals {
    api_data = {
      for k, v in local.current_api_gateway : k => v
    }
}

module "api-gateway-first" {
    source = "./modules/default"
    api_data = local.current_api_gateway[0]
    load_balancer = local.uri
    path = local.api_gateway_resource
}

module "api-gateway-second" {
    source = "./modules/default"
    api_data = local.current_api_gateway[1]
    load_balancer = local.uri
    path = local.api_gateway_resource
}
