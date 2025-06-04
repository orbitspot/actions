import json
import os

variables_json = os.getenv("variables_json", "{}")
setup = os.getenv("setup", {})

try:
    print(variables_json)
    variables = json.loads(variables_json)
except json.JSONDecodeError:
    print("Invalid JSON input")
    exit(1)


required=[]
match setup:
    case 'api':
        required=['_PROPERTIES','_POLICY_JSON']
    case 'frontend':
        required=['HOST_MF']
    case 'landingpage':
        required=['HOST_MF','ACM_ARN', '_PROPERTIES']
    case _:
        exit(1)

for item in required:
    print(variables[item])
    if variables[item] == '':
      exit(1)

