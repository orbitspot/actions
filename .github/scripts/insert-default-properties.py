import os
import json

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

default_properties = {}
with open(f"./orbitspot-actions/data/{chart_type}.json", "r") as f:
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
    properties_file.append(f"{placeholder}={value}")

with open(properties_path, 'w') as f:
  f.write(properties_file)