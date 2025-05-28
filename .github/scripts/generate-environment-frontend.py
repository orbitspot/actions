import json
import os

secrets_json = os.getenv("secrets_json", "{}")
variables_json = os.getenv("variables_json", "{}")
frontend_config = os.getenv("frontend_config", "{}")
branch = os.getenv("branch")

try:
    secrets = json.loads(secrets_json)
    variables = json.loads(variables_json)
    config = json.loads(frontend_config)
    config = config[branch]
except json.JSONDecodeError:
    print("Invalid JSON input")
    exit(1)

with open(".env", "a") as f:
    print(secrets)
    print(variables)
    print(config)
    devops_variables = ['CLUSTER_REGION', 'ENV', 'CLUSTER_NAME', 'ACCESS_KEY_CODE_ARTIFACT', 'GIT_TOKEN', 'PARAMETERS_ENCRYPT_HASH', 'SECRET_ACCESS_KEY_CODE_ARTIFACT', '_AWS_REGION',
                            'API_GATEWAY', 'DEVOPS_CONFIG', 'github_token', 'AWS_ACCOUNT_NUMBER', 'AWS_ROLE_NAME', 'ISTIO_HOST', 'TERRAFORM_BUCKET', 'API_HOST', 'DB_HOST', 'DB_PORT']
    for key, raw_value in secrets.items():
        # Try to parse value as nested JSON if it's a string
        if isinstance(raw_value, str):
            try:
                parsed_value = json.loads(raw_value)
                value = json.dumps(parsed_value)
            except json.JSONDecodeError:
                value = raw_value
        else:
            value = raw_value

        # Ensure string and properly escaped
        if key not in devops_variables and not key.startswith("_"): :
            f.write(f'{key}="{value}"\n')

    for key, raw_value in variables.items():
        # Try to parse value as nested JSON if it's a string
        if isinstance(raw_value, str):
            try:
                parsed_value = json.loads(raw_value)
                value = json.dumps(parsed_value)
            except json.JSONDecodeError:
                value = raw_value
        else:
            value = raw_value

        # Ensure string and properly escaped
        if key not in devops_variables and not key.startswith("_")::
            f.write(f'{key}="{value}"\n')

    for key, raw_value in config.items():
        # Try to parse value as nested JSON if it's a string
        if isinstance(raw_value, str):
            try:
                parsed_value = json.loads(raw_value)
                value = json.dumps(parsed_value)
            except json.JSONDecodeError:
                value = raw_value
        else:
            value = raw_value

        # Ensure string and properly escaped
        if key not in devops_variables and not key.startswith("_")::
            f.write(f'{key}="{value}"\n')
