import os
import re
import json

chart_type = os.getenv("CHART_TYPE", None)
properties_path = os.getenv('PROPERTIES_PATH')
prefix = os.getenv('PREFIX')

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
with open(f"./orbitspot-actions/data/{chart_type}.json", "r") as prop_file:
  default_properties = flatten_json(json.load(prop_file))

print("Default")
print(default_properties)

properties = {}
with open(properties_path, 'r') as prop_file:
  properties_file = prop_file.read()

  for line in prop_file:
    line = line.strip()
    if line and not line.startswith('#'):
      try:
        key, value = line.split('=', 1)
        properties[key.strip()] = value.strip()
      except ValueError as e:
        print(f"Erro ao processar linha: {line} - {e}")

print("Properties")
print(properties)

for key, value in default_properties.items():
  placeholder = f"${{{prefix}.{key}}}"
  if not key in properties:
    print(f"Inserindo valor default {placeholder}={value}")
    properties_file.append(f"{placeholder}={value}")

print("Properties file")
print(properties_file)

with open(properties_path, 'r') as prop_file:
  prop_file.write(properties_file)