locals {
    api_data = {
      for k, v in local.current_api_gateway : k => v
    }
}

#module "api-gateway-first" {
#    source = "./modules/default"
#    api_data = {
#        for index, value in local.api_data[0] : value["rest_api_id"] => value
#    }
#    load_balancer = local.uri
#    path = local.api_gateway_resource
#}
