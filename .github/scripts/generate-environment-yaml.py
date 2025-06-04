import yaml
import json
import os

def generate_yaml():
  environments = json.loads(os.getenv('environments'))
  secrets = json.loads(os.getenv('secrets'))
  repository_name = os.getenv('repository_name')

  devops_variables = ['CLUSTER_REGION', 'ENV', 'CLUSTER_NAME', 'ACCESS_KEY_CODE_ARTIFACT', 'GIT_TOKEN', 'PARAMETERS_ENCRYPT_HASH', 'SECRET_ACCESS_KEY_CODE_ARTIFACT', '_AWS_REGION',
                              'API_GATEWAY', 'DEVOPS_CONFIG', 'github_token', 'AWS_ACCOUNT_NUMBER', 'AWS_ROLE_NAME', 'ISTIO_HOST', 'TERRAFORM_BUCKET', 'API_HOST']
  
  result_environments = {"parameters": []}
  for key in environments.keys():
    if len(environments[key]) > 0 and key not in devops_variables and not key.startswith("_"):
      result_environments["parameters"].append({"context": "ssmparameter", "name": f'/{repository_name}/environment/{key}'}) 

  result_secrets = []
  for key in secrets.keys():
    if len(secrets[key]) > 0 and key not in devops_variables and not key.startswith("_"):
      result_secrets.append({"context": "ssmparameter", "name": f'/{repository_name}/secret/{key}'}) 

  with open(f"variables.yaml", "w") as outfile:
    yaml.dump(result_environments, outfile, default_flow_style=False)

  with open(f"variables.yaml", "a") as outfile:
    yaml.dump(result_secrets, outfile, default_flow_style=False)

generate_yaml()