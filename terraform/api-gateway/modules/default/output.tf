output "internal_docs" {
  value = {
    for index, value in var.api_data : index => data.aws_api_gateway_resource.internal_docs[index]
  }
}