module "proxy-get" {
  source               = "../../../api-gateway-resources"
  rest_api_id          = var.rest_api_id
  http_method          = "GET"
  method               = local.proxy.method
  integration          = merge(local.proxy.integration_get, { integration_http_method = "POST" })
  integration_response = local.proxy.integration_response
  method_response      = local.proxy.method_response
  resource_id          = var.resource_id
  vpc_id               = var.vpc_id
  region               = var.region
  load_balancer        = var.load_balancer
}

module "proxy-post" {
  source               = "../../../api-gateway-resources"
  rest_api_id          = var.rest_api_id
  http_method          = "POST"
  method               = local.proxy.method
  integration          = merge(local.proxy.integration, { integration_http_method = "POST" })
  integration_response = local.proxy.integration_response
  method_response      = local.proxy.method_response
  resource_id          = var.resource_id
  vpc_id               = var.vpc_id
  region               = var.region
  load_balancer        = var.load_balancer
}

module "proxy-put" {
  source               = "../../../api-gateway-resources"
  rest_api_id          = var.rest_api_id
  http_method          = "PUT"
  method               = local.proxy.method
  integration          = merge(local.proxy.integration, { integration_http_method = "PUT" })
  integration_response = local.proxy.integration_response
  resource_id          = var.resource_id
  method_response      = local.proxy.method_response
  vpc_id               = var.vpc_id
  region               = var.region
  load_balancer        = var.load_balancer
}

module "proxy-patch" {
  source               = "../../../api-gateway-resources"
  rest_api_id          = var.rest_api_id
  http_method          = "PATCH"
  method               = local.proxy.method
  integration          = merge(local.proxy.integration, { integration_http_method = "PATCH" })
  integration_response = local.proxy.integration_response
  method_response      = local.proxy.method_response
  resource_id          = var.resource_id
  vpc_id               = var.vpc_id
  region               = var.region
  load_balancer        = var.load_balancer
}

module "proxy-delete" {
  source               = "../../../api-gateway-resources"
  rest_api_id          = var.rest_api_id
  http_method          = "DELETE"
  method               = local.proxy.method
  integration          = merge(local.proxy.integration, { integration_http_method = "DELETE" })
  integration_response = local.proxy.integration_response
  method_response      = local.proxy.method_response
  resource_id          = var.resource_id
  vpc_id               = var.vpc_id
  region               = var.region
  load_balancer        = var.load_balancer
}

module "proxy-option" {
  source      = "../../../api-gateway-resources"
  rest_api_id = var.rest_api_id
  http_method = "OPTIONS"
  method = {
    authorization                   = "NONE"
    authorizer_id                   = ""
    request_method_api_key_required = false
    request_parameters              = {}
  }
  integration = {
    uri                     = ""
    type                    = "MOCK"
    integration_http_method = "OPTIONS"
    request_parameters      = {}
    request_templates = {
      "application/json" = "{ statusCode: 200 }"
    }
  }
  integration_response = {
    status_code        = { "200" : "" }
    response_templates = {}
    response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = "'*'",
      "method.response.header.Access-Control-Allow-Methods" = "'*'",
      "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    }
  }
  method_response = {
    status_code     = { "200" : "" }
    response_models = {}
    response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = true,
      "method.response.header.Access-Control-Allow-Methods" = true,
      "method.response.header.Access-Control-Allow-Origin"  = true
    }
  }
  resource_id = var.resource_id
  region      = var.region
}
