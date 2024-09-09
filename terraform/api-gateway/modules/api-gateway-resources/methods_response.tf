resource "aws_api_gateway_method_response" "default" {
    for_each                  = var.regex_mapping
    
    depends_on                = [ aws_api_gateway_method.default]
    http_method               = aws_api_gateway_method.default.http_method
    resource_id               = var.resource_id
    rest_api_id               = var.rest_api_id
    status_code               = each.key
    response_models           = var.method_response.response_models
    response_parameters       = var.method_response.response_parameters
}
