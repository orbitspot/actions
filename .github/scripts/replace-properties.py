import re
import os

def replace_properties_in_yaml(
        properties_path, 
        helm_values_path, 
        prefix, 
        helm_values_replace,
    ):
        print("Running replace-properties.py")
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
        with open(helm_values_path, 'r') as yaml_file:
            helm_values = yaml_file.read()
            
        # Substituir as chaves no YAML pelos valores do properties
        for key, value in properties.items():
            placeholder = f"${{{prefix}.{key}}}"
            if placeholder in helm_values:
                print(f"Substituindo {placeholder} por {value}")
                helm_values = re.sub(re.escape(placeholder), value, helm_values)

        if helm_values_replace:
            print("Substituindo em massa no arquivo.")
            helm_values = re.sub(
                '${{ vars.HELM_REPLACE_FILE }}'.format(), 
                helm_values_replace, 
                helm_values,
            )

        # Escrever o conteúdo modificado de volta ao arquivo YAML
        with open(helm_values_path, 'w') as yaml_file:
            yaml_file.write(helm_values)

        print(f"Substituicoes concluidas e salvas em {helm_values_path}")


properties_path = os.getenv('PROPERTIES_PATH')
helm_values_path = os.getenv('HELM_VALUES_PATH')
prefix = os.getenv('PREFIX')
helm_values_replace = os.getenv('HELM_REPLACE_FILE')

print(f"Properties: {properties_path}")
print(f"Helm values path: {helm_values_path}")
print(f"Prefix: {prefix}")
print(f"Helm Values to replace {helm_values_replace}")

replace_properties_in_yaml(
    properties_path, 
    helm_values_path, 
    prefix, 
    helm_values_replace,
)