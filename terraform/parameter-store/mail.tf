resource "aws_ssm_parameter" "vars" {
 for_each    = {
   for index, value in local.variables : index => value
 }
 name        = "/${var.repository}/environment/${each.key}"
 description = "Environment ${each.value} from module ${var.modulo}"
 type        = "String"
 value       = trimspace(each.value)
 tier        = "Standard"
 overwrite   = true # na proxima versão será removido, mas usar ele por enquanto
 tags = {
   Version = var.versionament
   "orbit:modulo": var.modulo
 }
}

resource "aws_ssm_parameter" "scrts" {
 for_each    = {
   for index, value in local.secrets : index => value
 }
 name        = "/${var.repository}/secret/${each.key}"
 description = "Secret ${each.value} from module ${var.modulo}"
 type        = "SecureString"
 value       = trimspace(replace(each.value, "$$", "$"))
 tier        = "Standard"
 overwrite   = true # na proxima versão será removido, mas usar ele por enquanto
 tags = {
   Version = var.versionament
   "orbit:modulo": var.modulo
 }
}


