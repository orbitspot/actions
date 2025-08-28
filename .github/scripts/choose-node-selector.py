import json
import yaml
import os
from dotenv import load_dotenv
dir_path = os.path.dirname(os.path.realpath(__file__))
print("aaaaaaaaaa")
print(dir_path)

load_dotenv('.env')

module = os.getenv("MODULE", "common")
repo = os.getenv("REPOSITORY") # ok
environment = os.getenv("ENV") # OK
deployment = os.getenv("DEPLOYMENT_NAME", None) # OK
chart_type = os.getenv("chart_type", None) # OK
properties = os.getenv("PROPERTIES")

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
private_machine = bool(props_dict.get(key_to_lookup))

# Escolhe node selector com base no arquivo data/node_selectors.json
if not node_selector:
  with open("../data/node_selectors.json", "r") as f:
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

# Substituir node selector pelo escolhido
# yaml_path = f"../data/{chart_type}.yaml"
yaml_path = f"../helm-values/{chart_type}.yaml"
with open(yaml_path, 'r') as yaml_file:
  yaml_content = yaml_file.read()
  yaml_content = yaml_content.replace(result, node_selector)

with open(yaml_path, 'w') as yaml_file:
  yaml_file.write(yaml_content)

print("NODE SELECTOR: ", node_selector)