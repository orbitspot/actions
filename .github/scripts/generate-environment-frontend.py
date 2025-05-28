import json
import os

secrets_json = os.getenv("secrets_json", "{}")
variables_json = os.getenv("variables_json", "{}")
frontend_config = os.getenv("frontend_config", "{}")
branch = os.getenv("branch")
print(secrets_json)
print(variables_json)
print(frontend_config)
print(branch)

try:
    secrets = json.loads(secrets_json)
    variables = json.loads(secrets_json)
    config = json.loads(frontend_config)
    config = config[branch]
except json.JSONDecodeError:
    print("Invalid JSON input")
    exit(1)

with open(".env", "a") as f:
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
        f.write(f'{key}="{value}"\n')
