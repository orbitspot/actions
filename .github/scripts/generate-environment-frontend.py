import os
import json

def generate_env():
  environments = json.loads(os.getenv('environments'))
  devops_variables = ['ACM_ARN', 'CLUSTER_REGION', 'ENV', 'CLUSTER_NAME', 'ACCESS_KEY_CODE_ARTIFACT', 'GIT_TOKEN', 'PARAMETERS_ENCRYPT_HASH', 'SECRET_ACCESS_KEY_CODE_ARTIFACT', 
                      'API_GATEWAY', 'DEVOPS_CONFIG', '_DEVOPS_CONFIG', 'github_token', 'AWS_ACCOUNT_NUMBER', 'AWS_ROLE_NAME', 'ISTIO_HOST', 'TERRAFORM_BUCKET', '_PROPERTIES', 'HOST_MF', '_POLICY_JSON']

  with open('.env', 'w+') as env:
    for key in environments:
      value = environments[key]
      if len(value) > 0 and key not in devops_variables: 
        env.write(f'{key}={value}\n')
  env.close()

generate_env()
