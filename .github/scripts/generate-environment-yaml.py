import yaml

def generate_yaml():
  environments = os.getenv('environments')
  secrets = os.getenv('secrets')

  devops_variables = ['CLUSTER_REGION', 'ENV', 'CLUSTER_NAME', 'ACCESS_KEY_CODE_ARTIFACT', 'GIT_TOKEN', 'PARAMETERS_ENCRYPT_HASH', 'SECRET_ACCESS_KEY_CODE_ARTIFACT', 
                      'API_GATEWAY', 'DEVOPS_CONFIG', '_DEVOPS_CONFIG', 'github_token', 'AWS_ACCOUNT_NUMBER', 'AWS_ROLE_NAME', 'ISTIO_HOST', 'TERRAFORM_BUCKET', '_PROPERTIES', '_POLICY_JSON']
  result_environments = []
  for key in environments:
    if len(environments[key]) > 0 and key not in devops_variables:
      result_environments.append({"context": "ssmparameter", "name": f'${{ github.event.repository.name }}/environment/{key}'}) 

  result_secrets = []
  for key in secrets:
    if len(secrets[key]) > 0 and key not in devops_variables:
      result_secrets.append({"context": "ssmparameter", "name": f'${{ github.event.repository.name }}/secret/{key}'}) 

  with open(f"variables.yaml", "w") as outfile:
    yaml.dump(result_environments, outfile, default_flow_style=False)

  with open(f"variables.yaml", "a") as outfile:
    yaml.dump(result_secrets, outfile, default_flow_style=False)


generate_yaml()