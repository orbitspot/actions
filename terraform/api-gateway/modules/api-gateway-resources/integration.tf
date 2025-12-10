resource "aws_api_gateway_integration" "default" {
  depends_on = [
    aws_api_gateway_method.default
  ]
  rest_api_id             = var.rest_api_id
  resource_id             = var.resource_id
  http_method             = aws_api_gateway_method.default.http_method
  integration_http_method = var.integration.integration_http_method
  type                    = var.integration.type
  uri                     = var.integration.uri
  request_parameters      = var.integration.request_parameters
  request_templates       = var.integration.request_templates
  timeout_milliseconds    = var.timeout_milliseconds
  passthrough_behavior    = "WHEN_NO_TEMPLATES"

  connection_type    = var.vpc_link_id != "" ? "VPC_LINK" : "INTERNET"
  connection_id      = var.vpc_link_id
  integration_target = var.load_balancer

  region = var.region
}
