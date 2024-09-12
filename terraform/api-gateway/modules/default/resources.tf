resource "aws_api_gateway_resource" "default" {
  parent_id     = var.api_data.parent_id
  path_part     = var.resource_name
  rest_api_id   = var.api_data.rest_api_id
}

resource "aws_api_gateway_resource" "proxy" {
  parent_id   = aws_api_gateway_resource.default.id
  path_part   = "{proxy+}"
  rest_api_id = var.api_data.rest_api_id
  depends_on  = [aws_api_gateway_resource.default]
}

resource "aws_api_gateway_resource" "internal_docs" {
  parent_id   = data.aws_api_gateway_resource.internal_docs.id
  path_part   = var.resource_name
  rest_api_id = var.api_data.rest_api_id
}