resource "aws_api_gateway_integration_response" "default" {
    count                     = var.integration_response_default != "" ? 1 : 0
    depends_on                = [ aws_api_gateway_integration.default, aws_api_gateway_method.default, aws_api_gateway_method_response.default ]
    http_method               = aws_api_gateway_method.default.http_method
    resource_id               = var.resource_id
    rest_api_id               = var.rest_api_id
    status_code               = var.integration_response_default.integration_response_status_code
    response_templates        = var.integration_response_default.response_templates
    response_parameters       = var.integration_response_default.response_parameters
}

resource "aws_api_gateway_integration_response" "proxy" {
    count                     = var.integration_response_proxy != "" ? 1 : 0
    for_each                  = var.regex_mapping
    
    depends_on                = [ aws_api_gateway_integration.default, aws_api_gateway_method.default, aws_api_gateway_method_response.default ]
    http_method               = aws_api_gateway_method.default.http_method
    resource_id               = var.resource_id
    rest_api_id               = var.rest_api_id
    status_code               = each.key
    response_templates        = var.integration_response.response_templates
    response_parameters       = var.integration_response.response_parameters
    selection_pattern         = each.value
}


