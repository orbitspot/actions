resource "aws_ssm_parameter" "vars" {
  for_each    = {
    for index, value in local.variables : index => value
  }
  name        = "/${var.repository}/environment/${var.versionament}/${each.key}"
  description = "Environment ${each.value} from module ${var.modulo}"
  type        = "String"
  value       = each.value
  tier        = "Standard"
  tags = {
    Version = var.versionament
    "orbit:modulo": var.modulo
  }
}

resource "aws_ssm_parameter" "scrts" {
  for_each    = {
    for index, value in local.variables : index => value
  }
  name        = "/${var.repository}/secret/${var.versionament}/${each.key}"
  description = "Secret ${each.value} from module ${var.modulo}"
  type        = "SecureString"
  value       = each.value
  tier        = "Standard"
  tags = {
    Version = var.versionament
    "orbit:modulo": var.modulo
  }
}


