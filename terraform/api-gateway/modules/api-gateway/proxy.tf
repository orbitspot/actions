resource "aws_api_gateway_resource" "proxy" {
  for_each      = var.api_data
  parent_id     = aws_api_gateway_resource.default[each.key].id
  path_part   = "{proxy+}"
  rest_api_id   = each.value["rest_api_id"]
  depends_on = [aws_api_gateway_resource.default]
}


//noinspection MissingModule
module "proxy-get" {
  for_each                    = var.api_data
  source                      = "git::https://github.com/orbitspot/infra-aws-api-gateway//terraform/modules/resource_definition?ref=v1.1.4"
  depends_on                  = [ aws_api_gateway_resource.proxy ]
  rest_api_id                 = aws_api_gateway_resource.proxy[each.key].rest_api_id
  http_method                 = "GET"
  method = local.proxy.method[each.key]
  integration = merge(local.proxy.integration, {integration_http_method = "GET"})
  integration_response = local.proxy.integration_response
  method_response = local.proxy.method_response
  resource_id = aws_api_gateway_resource.proxy[each.key].id
}

//noinspection MissingModule
module "proxy-post" {
  for_each                    = var.api_data
  source                      = "git::https://github.com/orbitspot/infra-aws-api-gateway//terraform/modules/resource_definition?ref=v1.1.4"
  depends_on                  = [ aws_api_gateway_resource.proxy ]
  rest_api_id                 = aws_api_gateway_resource.proxy[each.key].rest_api_id
  http_method                 = "POST"
  method = local.proxy.method[each.key]
  integration = merge(local.proxy.integration, {integration_http_method = "POST"})
  integration_response = local.proxy.integration_response
  method_response = local.proxy.method_response
  resource_id = aws_api_gateway_resource.proxy[each.key].id
}

//noinspection MissingModule
module "proxy-put" {
  for_each                    = var.api_data
  source                      = "git::https://github.com/orbitspot/infra-aws-api-gateway//terraform/modules/resource_definition?ref=v1.1.4"
  depends_on                  = [ aws_api_gateway_resource.proxy ]
  rest_api_id                 = aws_api_gateway_resource.proxy[each.key].rest_api_id
  http_method                 = "PUT"
  method = local.proxy.method[each.key]
  integration = merge(local.proxy.integration, {integration_http_method = "PUT"})
  integration_response = local.proxy.integration_response
  method_response = local.proxy.method_response
  resource_id = aws_api_gateway_resource.proxy[each.key].id
}

//noinspection MissingModule
module "proxy-patch" {
  for_each                    = var.api_data
  source                      = "git::https://github.com/orbitspot/infra-aws-api-gateway//terraform/modules/resource_definition?ref=v1.1.4"
  depends_on                  = [ aws_api_gateway_resource.proxy ]
  rest_api_id                 = aws_api_gateway_resource.proxy[each.key].rest_api_id
  http_method                 = "PATCH"
  method = local.proxy.method[each.key]
  integration = merge(local.proxy.integration, {integration_http_method = "PATCH"})
  integration_response = local.proxy.integration_response
  method_response = local.proxy.method_response
  resource_id = aws_api_gateway_resource.proxy[each.key].id
}

//noinspection MissingModule
module "proxy-delete" {
  for_each                    = var.api_data
  source                      = "git::https://github.com/orbitspot/infra-aws-api-gateway//terraform/modules/resource_definition?ref=v1.1.4"
  depends_on                  = [ aws_api_gateway_resource.proxy ]
  rest_api_id                 = aws_api_gateway_resource.proxy[each.key].rest_api_id
  http_method                 = "DELETE"
  method = local.proxy.method[each.key]
  integration = merge(local.proxy.integration, {integration_http_method = "DELETE"})
  integration_response = local.proxy.integration_response
  method_response = local.proxy.method_response
  resource_id = aws_api_gateway_resource.proxy[each.key].id
}

//noinspection MissingModule
module "proxy-option" {
  for_each                    = var.api_data
  source                      = "git::https://github.com/orbitspot/infra-aws-api-gateway//terraform/modules/resource_definition?ref=v1.1.4"
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
  resource_id = aws_api_gateway_resource.proxy[each.key].id
}
