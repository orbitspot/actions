locals {
  current_api_gateway = var.api_gateway[var.branch]
  current_host = var.hosts[var.branch]
  api_gateway_resource = replace(var.repository_name, "-", "")
  protocol = var.ssl ? "https" : "http"
  uri = "${local.protocol}://" + var.istio_enabled ? "${local.current_host}/${var.repository_name}/" : local.current_host
}