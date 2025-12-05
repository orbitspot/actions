module "v1" {
  count             = var.apply_response_script ? 1 : 0
  depends_on        = [aws_api_gateway_resource.proxy]
  source            = "./scripts/v1"
  load_balancer     = var.api_data.load_balancer
  path              = var.path
  custom_authorizer = var.api_data.custom_authorizer
  resource_id       = aws_api_gateway_resource.proxy.id
  rest_api_id       = aws_api_gateway_resource.proxy.rest_api_id
  vpc_id            = var.api_data.vpc_id
  region            = var.region
  uri               = var.uri
}

module "v2" {
  count             = var.apply_response_script ? 0 : 1
  depends_on        = [aws_api_gateway_resource.proxy]
  source            = "./scripts/v2"
  load_balancer     = var.api_data.load_balancer
  path              = var.path
  custom_authorizer = var.api_data.custom_authorizer
  resource_id       = aws_api_gateway_resource.proxy.id
  rest_api_id       = aws_api_gateway_resource.proxy.rest_api_id
  vpc_id            = var.api_data.vpc_id
  region            = var.region
  uri               = var.uri
}
