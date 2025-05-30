import json
import os

variables_json = os.getenv("variables_json", "{}")
setup = os.getenv("setup", {})

try:
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
        required=['HOST_MF','ACM_ARN']
    case _:
        exit(1)

for item in required:
    if item == '':
      exit(1)

