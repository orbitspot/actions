import re
import os
import yaml

def replace_properties_in_yaml(
    properties_path, yaml_path, prefix, replace_properties_yaml_path
):
    # Carregar o arquivo properties em um dicionário
    properties = {}
    with open(properties_path, 'r') as prop_file:
        for line in prop_file:
            line = line.strip()
            if line and not line.startswith('#'):
                try:
                    key, value = line.split('=', 1)
                    properties[key.strip()] = value.strip()
                except ValueError as e:
                    print(f"Erro ao processar linha: {line} - {e}")

    # Ler o conteúdo do arquivo YAML
    with open(yaml_path, 'r') as yaml_file:
        yaml_content = yaml_file.read()
        
    # Substituir as chaves no YAML pelos valores do properties
    for key, value in properties.items():
        placeholder = f"${{{prefix}.{key}}}"
        if placeholder in yaml_content:
            print(f"Substituindo {placeholder} por {value}")
            yaml_content = re.sub(re.escape(placeholder), value, yaml_content)
        
    # Ler o conteudo do arquivo YAML com propriedades e substituir
    if replace_properties_yaml_path:
        with open(replace_properties_yaml_path, 'r') as file:
            yaml_replace_properties_content = yaml.safe_load(file)
        
        yaml_content = yaml.safe_load(yaml_content)
        for key in yaml_replace_properties_content:
            if key in yaml_content:
                yaml_content[key] = yaml_replace_properties_content[key]
        with open(yaml_path, 'w') as yaml_file:
            yaml.dump(yaml_content, yaml_file)
    else:
        # Escrever o conteúdo modificado de volta ao arquivo YAML
        with open(yaml_path, 'w') as yaml_file:
            yaml_file.write(yaml_content)

    print(f"Substituicoes concluidas e salvas em {yaml_path}")


properties_path = os.getenv('PROPERTIES_PATH')
yaml_path = os.getenv('YAML_PATH')
prefix = os.getenv('PREFIX')
replace_properties_yaml_path = os.getenv('REPLACE_YAML_PATH')

print(f"Properties: {properties_path}")
print(f"Yaml: {yaml_path}")
print(f"Prefix: {prefix}")
print(f"Replace YAML Path: {replace_properties_yaml_path}")

replace_properties_in_yaml(
    properties_path, yaml_path, prefix, replace_properties_yaml_path
)