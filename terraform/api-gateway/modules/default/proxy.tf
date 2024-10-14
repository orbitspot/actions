module "v1" {
  count = var.apply_response_script ? 1 : 0
  source = "./scripts/v1"
  load_balancer = var.load_balancer
  path = var.path
  custom_authorizer = var.api_data.custom_authorizer
  resource_id = aws_api_gateway_resource.proxy.id
  rest_api_id = aws_api_gateway_resource.proxy.rest_api_id
}

module "v2" {
  count = var.apply_response_script ? 0 : 1
  source = "./scripts/v2"
  load_balancer = var.load_balancer
  path = var.path
  custom_authorizer = var.api_data.custom_authorizer
  resource_id = aws_api_gateway_resource.proxy.id
  rest_api_id = aws_api_gateway_resource.proxy.rest_api_id
}
