resource "aws_ssm_parameter" "vars" {
 for_each    = {
   for index, value in local.variables : index => value
 }
 name        = var.global ? "/${var.modulo}/environment/${each.key}" : "/${var.repository}/environment/${each.key}"
 description = substr(format("Environment %s from module %s", jsonencode(each.value), var.modulo), 0, 1023)
 type        = "String"
 value       = trimspace(each.value)
 tier        = "Standard"
 overwrite   = true # na proxima versão será removido, mas usar ele por enquanto
 tags = {
   "orbit:modulo": var.modulo
 }
}

resource "aws_ssm_parameter" "scrts" {
 for_each    = {
   for index, value in local.secrets : index => value
 }
 name        = var.global ? "/${var.modulo}/secret/${each.key}" : "/${var.repository}/secret/${each.key}"
 description = substr(format("Secret %s from module %s", jsonencode(each.key), var.modulo), 0, 1023)
 type        = "SecureString"
 value       = trimspace(replace(each.value, "$$", "$"))
 tier        = "Standard"
 overwrite   = true # na proxima versão será removido, mas usar ele por enquanto
 tags = {
   "orbit:modulo": var.modulo
 }
}


