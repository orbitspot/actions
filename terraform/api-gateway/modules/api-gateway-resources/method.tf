resource "aws_api_gateway_method" "default" {
  authorization      = var.method.authorization
  http_method        = var.http_method
  resource_id        = var.resource_id
  rest_api_id        = var.rest_api_id
  api_key_required   = var.method.request_method_api_key_required
  authorizer_id      = var.method.authorizer_id
  request_parameters = var.method.request_parameters
  region             = "us-east-1"
}
