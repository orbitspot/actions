module "v1" {
    count = var.apply_response_script ? 1 : 0
    source = "./scripts/v1"
    load_balancer = var.load_balancer
    path = var.path
    custom_authorizer = var.api_data.custom_authorizer
}

module "v2" {
    count = var.apply_response_script ? 0 : 1
    source = "./scripts/v2"
    load_balancer = var.load_balancer
    path = var.path
    custom_authorizer = var.api_data.custom_authorizer
}


locals {

    proxy = {
        method = var.apply_response_script ? module.v1.method : module.v2.method
        integration = var.apply_response_script ? module.v1.integration : module.v2.integration
        integration_get = var.apply_response_script ? module.v1.integration_get : module.v2.integration_get
        integration_response = var.apply_response_script ? module.v1.integration_response : module.v2.integration_response
        method_response = var.apply_response_script ? module.v1.method_response : module.v2.method_response
    }
}