import re
import os

def replace_properties_in_yaml(properties_path, yaml_path, prefix):
    print("Running replace-values.py")
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

    # Escrever o conteúdo modificado de volta ao arquivo YAML
    with open(yaml_path, 'w') as yaml_file:
        yaml_file.write(yaml_content)

    print(f"Substituicoes concluidas e salvas em {yaml_path}")


properties_path = os.getenv('PROPERTIES_PATH')
yaml_path = os.getenv('YAML_PATH')
prefix = os.getenv('PREFIX')

print(f"Properties: {properties_path}")
print(f"Yaml: {yaml_path}")
print(f"Prefix: {prefix}")

replace_properties_in_yaml(properties_path, yaml_path, prefix)