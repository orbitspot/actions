data "aws_api_gateway_resource" "internal_docs" {
  for_each    = var.api_data
  path        = "/internal-docs"
  rest_api_id = each.value["rest_api_id"]
}