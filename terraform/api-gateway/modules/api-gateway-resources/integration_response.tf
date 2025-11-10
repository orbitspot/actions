resource "aws_api_gateway_integration_response" "integration_201" {
  depends_on          = [aws_api_gateway_integration.default, aws_api_gateway_method.default, aws_api_gateway_method_response.default]
  http_method         = aws_api_gateway_method.default.http_method
  resource_id         = var.resource_id
  rest_api_id         = var.rest_api_id
  status_code         = "201"
  selection_pattern   = "201"
  response_templates  = var.integration_response.response_templates
  response_parameters = var.integration_response.response_parameters
  region              = "us-east-1"
}

resource "aws_api_gateway_integration_response" "integration_204" {
  depends_on          = [aws_api_gateway_integration.default, aws_api_gateway_method.default, aws_api_gateway_method_response.default]
  http_method         = aws_api_gateway_method.default.http_method
  resource_id         = var.resource_id
  rest_api_id         = var.rest_api_id
  status_code         = "204"
  selection_pattern   = "204"
  response_templates  = var.integration_response.response_templates
  response_parameters = var.integration_response.response_parameters
  region              = "us-east-1"
}

resource "aws_api_gateway_integration_response" "integration_403" {
  depends_on          = [aws_api_gateway_integration.default, aws_api_gateway_method.default, aws_api_gateway_method_response.default]
  http_method         = aws_api_gateway_method.default.http_method
  resource_id         = var.resource_id
  rest_api_id         = var.rest_api_id
  status_code         = "403"
  selection_pattern   = "403"
  response_templates  = var.integration_response.response_templates
  response_parameters = var.integration_response.response_parameters
  region              = "us-east-1"
}

resource "aws_api_gateway_integration_response" "integration_404" {
  depends_on          = [aws_api_gateway_integration.default, aws_api_gateway_method.default, aws_api_gateway_method_response.default]
  http_method         = aws_api_gateway_method.default.http_method
  resource_id         = var.resource_id
  rest_api_id         = var.rest_api_id
  status_code         = "404"
  selection_pattern   = "404"
  response_templates  = var.integration_response.response_templates
  response_parameters = var.integration_response.response_parameters
  region              = "us-east-1"
}

resource "aws_api_gateway_integration_response" "integration_400" {
  depends_on = [
    aws_api_gateway_integration.default,
    aws_api_gateway_method.default,
    aws_api_gateway_method_response.default,
    aws_api_gateway_integration_response.integration_201,
    aws_api_gateway_integration_response.integration_204,
    aws_api_gateway_integration_response.integration_403,
    aws_api_gateway_integration_response.integration_404
  ]
  http_method         = aws_api_gateway_method.default.http_method
  resource_id         = var.resource_id
  rest_api_id         = var.rest_api_id
  status_code         = "400"
  selection_pattern   = "4.*"
  response_templates  = var.integration_response.response_templates
  response_parameters = var.integration_response.response_parameters
  region              = "us-east-1"
}

resource "aws_api_gateway_integration_response" "integration_500" {
  depends_on = [
    aws_api_gateway_integration.default,
    aws_api_gateway_method.default,
    aws_api_gateway_method_response.default,
    aws_api_gateway_integration_response.integration_201,
    aws_api_gateway_integration_response.integration_204,
    aws_api_gateway_integration_response.integration_403,
    aws_api_gateway_integration_response.integration_404
  ]
  http_method         = aws_api_gateway_method.default.http_method
  resource_id         = var.resource_id
  rest_api_id         = var.rest_api_id
  status_code         = "500"
  selection_pattern   = "5.*"
  response_templates  = var.integration_response.response_templates
  response_parameters = var.integration_response.response_parameters
  region              = "us-east-1"
}

resource "aws_api_gateway_integration_response" "integration_200" {
  depends_on = [
    aws_api_gateway_integration.default,
    aws_api_gateway_method.default,
    aws_api_gateway_method_response.default,
    aws_api_gateway_integration_response.integration_201,
    aws_api_gateway_integration_response.integration_204,
    aws_api_gateway_integration_response.integration_403,
    aws_api_gateway_integration_response.integration_404
  ]
  http_method         = aws_api_gateway_method.default.http_method
  resource_id         = var.resource_id
  rest_api_id         = var.rest_api_id
  status_code         = "200"
  selection_pattern   = "20[0-35-9]"
  response_templates  = var.integration_response.response_templates
  response_parameters = var.integration_response.response_parameters
  region              = "us-east-1"
}
