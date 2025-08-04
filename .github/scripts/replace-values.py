import os
import yaml

yaml_path = os.getenv('YAML_PATH')
replace_properties_yaml_path = os.getenv('REPLACE_YAML_PATH')

print(f"Yaml: {yaml_path}")
print(f"Yaml Replace: {replace_properties_yaml_path}")

if not replace_properties_yaml_path:
  exit(0)

# Ler o conteúdo do arquivo YAML
with open(yaml_path, 'r') as file:
  yaml_content = yaml.safe_load(file)

# Ler o conteudo do arquivo yaml a substituir
with open(replace_properties_yaml_path, 'r') as file:
  yaml_replace_properties_content = yaml.safe_load(file)

for key in yaml_replace_properties_content:
  if key in yaml_content:
    yaml_content[key] = yaml_replace_properties_content[key]

with open(yaml_path, 'w') as yaml_file:
  yaml.dump(yaml_content, yaml_file)