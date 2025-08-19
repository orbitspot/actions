resource "aws_api_gateway_resource" "internal_docs" {
  parent_id   = data.aws_api_gateway_resource.internal_docs.id
  path_part   = var.path
  rest_api_id = var.api_data.rest_api_id
}
