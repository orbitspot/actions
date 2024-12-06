output "secrets" {
  value = replace(local.secrets, "$$", "$")
}

output "vars" {
  value = local.variables
}