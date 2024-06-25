module "proxy-get" {
  for_each                    = aws_api_gateway_resource.proxy
  source                      = "../api-gateway-resources"
  depends_on                  = [ aws_api_gateway_resource.proxy ]
  rest_api_id                 = aws_api_gateway_resource.proxy[each.key].rest_api_id
  http_method                 = "GET"
  method                      = local.proxy.method[each.key]
  integration                 = merge(local.proxy.integration, {integration_http_method = "GET"})
  integration_response        = local.proxy.integration_response
  method_response             = local.proxy.method_response
  resource_id                 = each.value.id
}

module "proxy-post" {
  for_each                    = aws_api_gateway_resource.proxy
  source                      = "../api-gateway-resources"
  depends_on                  = [ aws_api_gateway_resource.proxy ]
  rest_api_id                 = aws_api_gateway_resource.proxy[each.key].rest_api_id
  http_method                 = "POST"
  method = local.proxy.method[each.key]
  integration = merge(local.proxy.integration, {integration_http_method = "POST"})
  integration_response = local.proxy.integration_response
  method_response = local.proxy.method_response
  resource_id = each.value.id
}

module "proxy-put" {
  for_each                    = aws_api_gateway_resource.proxy
  source                      = "../api-gateway-resources"
  depends_on                  = [ aws_api_gateway_resource.proxy ]
  rest_api_id                 = aws_api_gateway_resource.proxy[each.key].rest_api_id
  http_method                 = "PUT"
  method = local.proxy.method[each.key]
  integration = merge(local.proxy.integration, {integration_http_method = "PUT"})
  integration_response = local.proxy.integration_response
  method_response = local.proxy.method_response
  resource_id = each.value.id
}

module "proxy-patch" {
  for_each                    = aws_api_gateway_resource.proxy
  source                      = "../api-gateway-resources"
  depends_on                  = [ aws_api_gateway_resource.proxy ]
  rest_api_id                 = aws_api_gateway_resource.proxy[each.key].rest_api_id
  http_method                 = "PATCH"
  method = local.proxy.method[each.key]
  integration = merge(local.proxy.integration, {integration_http_method = "PATCH"})
  integration_response = local.proxy.integration_response
  method_response = local.proxy.method_response
  resource_id = each.value.id
}

module "proxy-delete" {
  for_each                    = aws_api_gateway_resource.proxy
  source                      = "../api-gateway-resources"
  depends_on                  = [ aws_api_gateway_resource.proxy ]
  rest_api_id                 = aws_api_gateway_resource.proxy[each.key].rest_api_id
  http_method                 = "DELETE"
  method = local.proxy.method[each.key]
  integration = merge(local.proxy.integration, {integration_http_method = "DELETE"})
  integration_response = local.proxy.integration_response
  method_response = local.proxy.method_response
  resource_id = each.value.id
}

module "proxy-option" {
  for_each                    = aws_api_gateway_resource.proxy
  source                      = "../api-gateway-resources"
  depends_on                  = [
    aws_api_gateway_resource.proxy
  ]
  rest_api_id                 = aws_api_gateway_resource.proxy[each.key].rest_api_id
  http_method                 = "OPTIONS"
  method = {
    authorization  = "NONE"
    authorizer_id   = ""
    request_method_api_key_required = false
    request_parameters = {}
  }
  integration = {
    uri = ""
    type = "MOCK"
    integration_http_method = "OPTIONS"
    request_parameters = {}
    request_templates = {
      "application/json" = "{ statusCode: 200 }"
    }
  }
  integration_response = {
    integration_response_status_code = "200"
    response_templates = {}
    response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token,token,X-Requested-With,Cache-Control,accesstoken'",
      "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,GET,PUT,POST,DELETE,PATCH,HEAD'",
      "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    }
  }
  method_response = {
    status_code = "200"
    response_models = {}
    response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = true,
      "method.response.header.Access-Control-Allow-Methods" = true,
      "method.response.header.Access-Control-Allow-Origin" = true
    }
  }
  resource_id = each.value.id
}
