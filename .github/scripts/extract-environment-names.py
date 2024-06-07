import yaml
import json
import os

def read_yaml(file_path):
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)
    return data

def filter_parameters(data, prefix):
    filtered = [param['name'].replace(prefix, '') for param in data['parameters'] if param['name'].startswith(prefix)]
    return filtered

def main(yaml_file, prefix):
    data = read_yaml(yaml_file)
    filtered_params = filter_parameters(data, prefix)
    return json.dumps(filtered_params)

yaml_file_path = os.getenv('PARAMETERS_FILE')
prefix = os.getenv('PREFIX')
result = main(yaml_file_path, prefix)
print(result)
