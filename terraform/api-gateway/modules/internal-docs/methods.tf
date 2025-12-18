module "get" {
  source        = "../api-gateway-resources"
  region        = var.region
  rest_api_id   = var.api_data.rest_api_id
  vpc_link_id   = var.vpc.link_id
  load_balancer = var.vpc.load_balancer
  http_method   = "GET"
  method = {
    authorization                   = "NONE"
    authorizer_id                   = ""
    request_method_api_key_required = false
    request_parameters              = {}
  }
  integration = {
    integration_http_method = "GET"
    uri                     = "${var.uri}/${var.docs}"
    type                    = "HTTP"
    request_parameters = {
      "integration.request.header.target" = "'${var.path}'"
    }
    request_templates = {}
  }
  integration_response = {
    status_code = { "200" : "" }
    response_templates = {
      "application/json" = ""
    }
    response_parameters = {
      "method.response.header.Access-Control-Allow-Origin" = "'*'",
    }
  }
  method_response = {
    response_models = {
      "application/json" = "Empty"
    }
    response_parameters = {
      "method.response.header.Access-Control-Allow-Origin" = true
    }
    status_code = { "200" : "" }
  }
  resource_id = aws_api_gateway_resource.internal_docs.id
}

module "options" {
  source      = "../api-gateway-resources"
  region      = var.region
  rest_api_id = var.api_data.rest_api_id
  http_method = "OPTIONS"
  method = {
    authorization                   = "NONE"
    authorizer_id                   = ""
    request_method_api_key_required = false
    request_parameters              = {}
  }
  integration = {
    integration_http_method = "OPTIONS"
    uri                     = ""
    type                    = "MOCK"
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
  resource_id = aws_api_gateway_resource.internal_docs.id
}
