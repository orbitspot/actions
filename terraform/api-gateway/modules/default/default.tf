module "default-get" {
  source                      = "../api-gateway-resources"
  depends_on                  = [
    aws_api_gateway_resource.default
  ]
  rest_api_id                 = var.api_data.rest_api_id
  http_method                 = "GET"
  method = {
    authorization = "NONE"
    authorizer_id = ""
    request_method_api_key_required = false
    request_parameters = {}
  }
  integration = {
    uri = var.istio_enabled ? "${var.load_balancer}/" : var.load_balancer
    type = "HTTP"
    integration_http_method = "GET"
    request_parameters = {
      "integration.request.header.target" = "'${var.path}'"
    }
    request_templates = {
      "application/json" = <<EOF
      #set($allParams = $input.params())
      #set($inputRoot = $input.path('$'))
      {
      #foreach($key in $inputRoot.keySet())
          "$key": "$inputRoot.get($key)"#if($foreach.hasNext()),#end
      #end,
      "api-gateway-params" : {
      "context" : {
          "authorizations": "$context.authorizer.authorizations"
          },
      #foreach($type in $allParams.keySet())
          #set($params = $allParams.get($type))
      "$type" : {
          #foreach($paramName in $params.keySet())
          "$paramName" : "$util.escapeJavaScript($params.get($paramName))"
              #if($foreach.hasNext),#end
          #end
      }
          #if($foreach.hasNext),#end
      #end
      }
      }
      EOF
  }
  }
  integration_response = {
    integration_response_status_code = "200"
    response_templates = {}
    response_parameters = {}
  }
  method_response = {
    response_models = {
      "application/json" = "Empty"
    }
    response_parameters = {}
    status_code = "200"
  }
  resource_id = aws_api_gateway_resource.default.id
}


module "default-option" {
  source                      = "../api-gateway-resources"
  depends_on                  = [
    aws_api_gateway_resource.default
  ]
  rest_api_id                 = var.api_data.rest_api_id
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
  resource_id = aws_api_gateway_resource.default.id
}

