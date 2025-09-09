resource "aws_api_gateway_integration_response" "default" {
    for_each                  = var.integration_response.status_code
    depends_on                = [ aws_api_gateway_integration.default, aws_api_gateway_method.default, aws_api_gateway_method_response.default ]
    http_method               = aws_api_gateway_method.default.http_method
    resource_id               = var.resource_id
    rest_api_id               = var.rest_api_id
    status_code               = each.key
    selection_pattern         = each.value
    response_templates        = var.integration_response.response_templates
    response_parameters       = var.integration_response.response_parameters
    region                    = "us-east-1"
}
