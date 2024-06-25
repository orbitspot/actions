#module "api-gateway" {
#    source = "./modules/default"
#    api_data = {
#      for k, v in local.current_api_gateway : v["rest_api_id"] => v
#    }
#    load_balancer = local.uri
#    path = local.api_gateway_resource
#}
#
#
#
