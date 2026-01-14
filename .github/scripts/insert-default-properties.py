import os
import json
from pathlib import Path

chart_type = os.getenv("CHART_TYPE", None)
properties_path = os.getenv('PROPERTIES_PATH')
deployment = os.getenv("DEPLOYMENT_NAME", None)

def flatten_json(data, parent_key="", sep="."):
  items = {}

  if isinstance(data, dict):
    for k, v in data.items():
      new_key = f"{parent_key}{sep}{k}" if parent_key else k
      items.update(flatten_json(v, new_key, sep))
  
  elif isinstance(data, list):
    for i, v in enumerate(data):
      new_key = f"{parent_key}{sep}{i}"
      items.update(flatten_json(v, new_key, sep))
  else:
    items[parent_key] = data
  
  return items

def set_default_requests(default_properties: dict, properties: dict, properties_file):
  requests_resources = ['resources.requests.cpu', 'resources.requests.memory']
  
  for item in requests_resources:
    placeholder = f"{deployment}.{item}"
  if not placeholder in properties:
    print(f"{item} nao encontrado - utilizando valor default igual ao limits")
    default_item = item.replace('requests', 'limits')
    value = properties.get(
      f"{deployment}.{default_item}",
      default_properties[default_item])
    properties_file += f"\n{placeholder}={value}"

default_properties_path = f"./orbitspot-actions/data/default-properties/{chart_type}.json"
path = Path(default_properties_path)
if not path.exists():
  exit(0)

default_properties = {}
with open(default_properties_path, "r") as f:
  default_properties = flatten_json(json.load(f))

properties = {}
with open(properties_path, 'r') as f:
  properties_file = f.read()

for line in properties_file.splitlines():
  line = line.strip()
  if line and not line.startswith('#'):
    try:
      key, value = line.split('=', 1)
      properties[key.strip()] = value.strip()
    except ValueError as e:
      print(f"Erro ao processar linha: {line} - {e}")

items = default_properties.items()
for key, value in items:
  placeholder = f"{deployment}.{key}"
  if not placeholder in properties:
    print(f"Inserindo valor default {placeholder}={value}")
    properties_file += f"\n{placeholder}={value}"

print("values.properties")
print(properties_file)

set_default_requests(default_properties, properties, properties_file)

with open(properties_path, 'w') as f:
  f.write(properties_file)