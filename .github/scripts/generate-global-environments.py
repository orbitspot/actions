import json
import os

variables = os.getenv("variables_json", "{}")
module = os.getenv("module")

result_json = {}
print("Variables: ", variables)
for key in variables.keys():
  print("Key: ", key)
  value = variables[key].replace("$", "$$") # no terraform $$ é o escapamento para o $ 
  print(key.split("_")[1])
  if len(value) > 0 and key.split("_")[1] == module.upper(): # adiciona apenas as variáveis do módulo selecionado
    result_json.update({key: value}) 

with open(f"${{ inputs.file_name }}.json", "w") as outfile:
  json.dump(result_json, outfile)