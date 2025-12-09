locals {
  current_api_gateway  = var.api_gateway[var.branch]
  current_host         = var.hosts[var.branch]
  api_gateway_resource = var.resource_name != "" ? var.resource_name : replace(var.repository_name, "-", "")
  ssl                  = local.current_api_gateway[0].vpc.link_id != ""
  protocol             = local.ssl ? "https" : "http"
  uri                  = var.istio_enabled ? "${local.protocol}://${local.current_host}/${var.repository_name}" : "${local.protocol}://${local.current_host}"
  region               = local.current_api_gateway[0].region
}
