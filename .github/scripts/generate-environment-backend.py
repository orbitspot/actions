import yaml
import json
import os

def generate_yaml():
  environments = json.loads(os.getenv('VARS'))
  secrets = json.loads(os.getenv('SECRETS'))
  repository_name = os.getenv('REPOSITORY_NAME')
  module = os.getenv('MODULE')

  devops_variables = ['CLUSTER_REGION', 'ENV', 'CLUSTER_NAME', 'ACCESS_KEY_CODE_ARTIFACT', 'GIT_TOKEN', 'PARAMETERS_ENCRYPT_HASH', 'SECRET_ACCESS_KEY_CODE_ARTIFACT',
                              'API_GATEWAY', 'DEVOPS_CONFIG', 'github_token', 'AWS_ACCOUNT_NUMBER', 'AWS_ROLE_NAME', 'ISTIO_HOST', 'TERRAFORM_BUCKET', 'API_HOST']
  
  result_environments = {"parameters": []}
  for key in environments.keys():
    if len(environments[key]) > 0 and key not in devops_variables and not key.startswith("_"):
      result_environments["parameters"].append({"context": "ssmparameter", "name": f'/{repository_name}/environment/{key}'}) 
    elif len(environments[key]) > 0 and key.split("_")[1] == module.upper():
      result_environments["parameters"].append({"context": "ssmparameter", "name": f'/{module}/environment/{key}'})

  result_secrets = []
  for key in secrets.keys():
    if len(secrets[key]) > 0 and key not in devops_variables and not key.startswith("_"):
      result_secrets.append({"context": "ssmparameter", "name": f'/{repository_name}/secret/{key}'}) 
    elif len(secrets[key]) > 0 and key.split("_")[1] == module.upper():
      result_secrets.append({"context": "ssmparameter", "name": f'/{module}/secret/{key}'})

  
  with open(f"variables.yaml", "w") as outfile:
    yaml.dump(result_environments, outfile, default_flow_style=False)

  if result_secrets:
    with open(f"variables.yaml", "a") as outfile:
      yaml.dump(result_secrets, outfile, default_flow_style=False)

generate_yaml()