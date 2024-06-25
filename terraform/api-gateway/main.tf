locals {
    api_data = {
      for k, v in local.current_api_gateway : k => v
    }
}

module "api-gateway-first" {
    source = "./modules/default"
    api_data = {
      for k, v in local.current_api_gateway[0] : v["rest_api_id"] => v
    }
    load_balancer = local.uri
    path = local.api_gateway_resource
}
