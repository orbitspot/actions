#resource "aws_api_gateway_integration" "default" {
#    depends_on                = [
#      aws_api_gateway_method.default
#    ]
#    http_method               = aws_api_gateway_method.default.http_method
#    integration_http_method   = var.integration.integration_http_method
#    resource_id               = var.resource_id
#    rest_api_id               = var.rest_api_id
#    uri                       = var.integration.uri
#    type                      = var.integration.type
#    request_parameters        = var.integration.request_parameters
#    request_templates         = var.integration.request_templates
#    timeout_milliseconds      = var.timeout_milliseconds
#    passthrough_behavior      = "WHEN_NO_TEMPLATES"
#}
