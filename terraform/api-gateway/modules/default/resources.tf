resource "aws_api_gateway_resource" "default" {
  parent_id   = var.api_data.parent_id
  path_part   = var.path
  rest_api_id = var.api_data.rest_api_id
  region      = var.region
}

resource "aws_api_gateway_resource" "proxy" {
  parent_id   = aws_api_gateway_resource.default.id
  path_part   = "{proxy+}"
  rest_api_id = var.api_data.rest_api_id
  depends_on  = [aws_api_gateway_resource.default]
  region      = var.region
}
