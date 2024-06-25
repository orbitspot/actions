resource "aws_api_gateway_resource" "default" {
  for_each      = var.api_data
  parent_id     = each.value["parent_id"]
  path_part     = var.path
  rest_api_id   = each.value["rest_api_id"]
}

resource "aws_api_gateway_resource" "proxy" {
  for_each      = var.api_data
  parent_id     = aws_api_gateway_resource.default[each.key].id
  path_part   = "{proxy+}"
  rest_api_id   = each.value["rest_api_id"]
  depends_on = [aws_api_gateway_resource.default]
}

resource "aws_api_gateway_resource" "internal_docs" {
  for_each    = var.api_data
  parent_id   = data.aws_api_gateway_resource.internal_docs[each.key].id
  path_part   = var.path
  rest_api_id = each.value["rest_api_id"]
}