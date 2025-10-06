import json
import yaml
import os

module = os.getenv("MODULE", "common") #OK
repo = os.getenv("REPOSITORY") # OK
environment = os.getenv("ENV") # OK
deployment = os.getenv("DEPLOYMENT_NAME", None) # OK
properties = os.getenv("PROPERTIES")
helm_values_path = os.getenv("HELM_VALUES_PATH")

# Processa properties
props_dict = {}
if properties:
    # Split lines and remove empty lines
    for line in properties.splitlines():
        line = line.strip()
        if not line:
            continue
        if '=' in line:
            key, value = line.split('=', 1)
            props_dict[key.strip()] = value.strip()

# Access the value by key
key_to_lookup = f"{deployment}.node_selector"
node_selector = props_dict.get(key_to_lookup)
key_to_lookup = f"{deployment}.private"
private_machine = False if not props_dict.get(key_to_lookup) else props_dict.get(key_to_lookup).capitalize() == "True"

# Escolhe node selector com base no arquivo data/node_selectors.json
if not node_selector:
  with open("./orbitspot-actions/data/node_selectors.json", "r") as f:
    data = json.load(f)

  key = f'{repo}-{deployment}'
  exclusive_machine = data[environment][module].get(key)
  if exclusive_machine:
    node_selector = exclusive_machine
  else:
    machine_type = 'private' if private_machine else 'public'
    node_selector = data[environment][module][machine_type]

placeholder_template = "${{.{repo}.{deployment}.node_selector}}"
result = placeholder_template.format(repo=repo, deployment=deployment)

with open(helm_values_path, 'r') as yaml_file:
  yaml_content = yaml_file.read()
  yaml_content = yaml_content.replace(result, node_selector)

with open(helm_values_path, 'w') as yaml_file:
  yaml_file.write(yaml_content)

print("NODE SELECTOR: ", node_selector)