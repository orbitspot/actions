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
    case 'migration':
        required=['_PROPERTIES_MIGRATION']
    case 'scaledjob':
        required=['_PROPERTIES_SCALEDJOB']
    case 'cronjob':
        required=['_PROPERTIES_CRONJOB']
    case 'api':
        required=['_PROPERTIES_API']
    case 'frontend':
        required=['HOST_MF']
    case 'landingpage':
        required=['HOST_MF','ACM_ARN', '_PROPERTIES']
    case _:
        exit(0)

for item in required:
    if item not in variables or variables[item] == '':
      print("❌", item, "is missing!")
      exit(1)

