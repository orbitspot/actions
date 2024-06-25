#module "api-gateway" {
#    source = "./modules/api-gateway"
#    api_data = {
#      for k, v in var.api_data : v["rest_api_id"] => v
#    }
#    load_balancer = var.load_balancer
#    path = "securityservice"
#}
#


