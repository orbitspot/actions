module "default-get" {
  source        = "../api-gateway-resources"
  rest_api_id   = var.api_data.rest_api_id
  vpc_id        = var.vpc.vpc_link_id
  load_balancer = var.vpc.load_balancer
  region        = var.region
  http_method   = "GET"
  method = {
    authorization                   = "NONE"
    authorizer_id                   = ""
    request_method_api_key_required = false
    request_parameters              = {}
  }
  integration = {
    uri                     = var.istio_enabled ? "${var.uri}/" : var.uri
    type                    = "HTTP"
    integration_http_method = "GET"
    request_parameters = {
      "integration.request.header.target" = "'${var.path}'"
    }
    request_templates = {
      "application/json" = ""
    }
  }
  integration_response = {
    status_code         = { "200" : "" }
    response_templates  = {}
    response_parameters = {}
  }
  method_response = {
    response_models = {
      "application/json" = "Empty"
    }
    response_parameters = {}
    status_code         = { "200" : "" }
  }
  resource_id = aws_api_gateway_resource.default.id
}


module "default-option" {
  source      = "../api-gateway-resources"
  rest_api_id = var.api_data.rest_api_id
  region      = var.region
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
  resource_id = aws_api_gateway_resource.default.id
}

