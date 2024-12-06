output "secrets" {
  value = local.secrets
}

output "vars" {
  value = replace(local.variables, "$$", "$")
}