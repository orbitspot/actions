output "secrets" {
  value = replace(local.secrets, "$$", "$")
}

output "vars" {
  value = replace(local.variables, "$$", "$")
}