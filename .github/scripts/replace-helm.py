import os
import yaml

helm_values_path = os.getenv('HELM_VALUES_PATH')
custom_helm_values_path = os.getenv('CUSTOM_HELM_VALUES_PATH')

print("Running replace-helm.py")
print(f"Original Helm Values: {helm_values_path}")
print(f"Custom Helm Values: {custom_helm_values_path}")

if not custom_helm_values_path:
  exit(0)

# Ler o conteúdo do arquivo YAML
with open(helm_values_path, 'r') as file:
  yaml_content = yaml.safe_load(file)

# Ler o conteudo do arquivo yaml a substituir
with open(custom_helm_values_path, 'r') as file:
  yaml_replace_content = yaml.safe_load(file)

for key in yaml_replace_content:
  if key in yaml_content:
    yaml_content[key] = yaml_replace_content[key]

with open(helm_values_path, 'w') as yaml_file:
  yaml.dump(yaml_content, yaml_file)