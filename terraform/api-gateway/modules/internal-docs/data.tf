data "aws_api_gateway_resource" "internal_docs" {
  path        = "/internal-docs"
  rest_api_id = var.api_data.rest_api_id
}
