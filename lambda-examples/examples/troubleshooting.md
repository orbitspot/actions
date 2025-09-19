# Guia de Troubleshooting - Lambda Examples

Este guia ajuda a resolver problemas comuns ao usar o sistema de deploy de Lambda.

## Problemas Comuns

### 1. Erro no GitHub Workflow

#### Erro: "Environment not found"
```
Error: The environment 'develop' was not found
```

**Solução:**
1. Vá para Settings → Environments no seu repositório GitHub
2. Crie os environments: `develop`, `homolog`, `master`
3. Configure as variáveis de ambiente conforme os arquivos em `examples/environments/`

#### Erro: "Invalid JSON in environment variable"
```
Error: invalid character 'x' after top-level value
```

**Solução:**
1. Verifique se todas as variáveis JSON estão corretamente formatadas
2. Use ferramentas como jsonlint.com para validar
3. Exemplo correto:
   ```
   LAMBDA_ENV_VARS={"NODE_ENV":"development","LOG_LEVEL":"debug"}
   ```

### 2. Problemas de Deploy Terraform

#### Erro: "Lambda function already exists"
```
Error: error creating Lambda Function: ResourceConflictException
```

**Solução:**
```bash
# 1. Importar a função existente
terraform import aws_lambda_function.this <function-name>

# 2. Ou destruir e recriar
terraform destroy -target=aws_lambda_function.this
terraform apply
```

#### Erro: "IAM role cannot be assumed"
```
Error: The role defined for the function cannot be assumed by Lambda
```

**Solução:**
1. Verifique se o trust policy está correto no IAM role
2. Aguarde alguns minutos para propagação das permissões
3. Verifique se a região está correta

### 3. Problemas de Triggers

#### S3 Trigger não funciona
```
Lambda function not triggered by S3 events
```

**Verificações:**
1. Bucket existe e está na mesma região da Lambda
2. Permissões do bucket permitem invocar a Lambda
3. Filtros de prefix/suffix estão corretos
4. Não há conflito com outros event notifications no bucket

**Debug:**
```bash
# Verificar configuração do bucket
aws s3api get-bucket-notification-configuration --bucket lambda-examples-uploads-develop

# Testar trigger manualmente
aws lambda invoke --function-name <function-name> \
  --payload file://s3-test-event.json response.json
```

#### SQS Trigger não funciona
```
Lambda function not processing SQS messages
```

**Verificações:**
1. Queue existe e tem mensagens
2. Lambda tem permissão para ler da queue
3. Visibility timeout da queue é maior que o timeout da Lambda
4. Dead Letter Queue configurada se necessário

**Debug:**
```bash
# Verificar mensagens na queue
aws sqs get-queue-attributes --queue-url <queue-url> --attribute-names All

# Verificar event source mapping
aws lambda list-event-source-mappings --function-name <function-name>
```

#### API Gateway retorna 500
```
Internal server error from API Gateway
```

**Verificações:**
1. Lambda function está deployada e ativa
2. API Gateway tem permissão para invocar a Lambda
3. Formato de resposta da Lambda está correto para API Gateway

**Formato correto de resposta:**
```javascript
return {
    statusCode: 200,
    headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
    },
    body: JSON.stringify({
        message: 'Success'
    })
};
```

### 4. Problemas de Performance

#### Lambda Timeout
```
Task timed out after X seconds
```

**Soluções:**
1. Aumentar timeout nas configurações de environment
2. Otimizar código para operações assíncronas
3. Implementar paginação para processamento de lotes
4. Usar Step Functions para workflows longos

#### Cold Start Problems
```
Lambda taking too long to start
```

**Soluções:**
1. Usar Provisioned Concurrency para funções críticas
2. Manter o código pequeno e dependencies mínimas
3. Implementar warmup via CloudWatch Events
4. Usar layers para dependencies comuns

### 5. Monitoramento e Debug

#### CloudWatch Logs não aparecem
```
No logs showing in CloudWatch
```

**Verificações:**
1. IAM role tem permissão para logs:CreateLogGroup/CreateLogStream/PutLogEvents
2. Log group está na região correta
3. Lambda está sendo realmente invocada

#### Métricas incorretas
```
CloudWatch metrics showing unexpected values
```

**Verificações:**
1. Timezone correto nas métricas
2. Período de agregação adequado
3. Filtros aplicados corretamente

### 6. Comandos Úteis para Debug

#### Verificar status da Lambda
```bash
aws lambda get-function --function-name <function-name>
aws lambda get-function-configuration --function-name <function-name>
```

#### Testar Lambda localmente
```bash
# Usar SAM CLI
sam local invoke <function-name> -e event.json

# Ou invocar diretamente
aws lambda invoke --function-name <function-name> \
  --payload '{"test": true}' response.json
```

#### Verificar logs
```bash
aws logs describe-log-groups --log-group-name-prefix "/aws/lambda/"
aws logs tail /aws/lambda/<function-name> --follow
```

#### Verificar event source mappings
```bash
aws lambda list-event-source-mappings --function-name <function-name>
```

### 7. Validação de Environment Variables

#### Script para validar configurações:
```bash
#!/bin/bash

echo "Validando configurações do environment..."

# Verificar se variáveis obrigatórias existem
required_vars=(
    "LAMBDA_TIMEOUT"
    "LAMBDA_MEMORY_SIZE" 
    "LAMBDA_ENV_VARS"
)

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ Variável $var não está definida"
    else
        echo "✅ $var: ${!var}"
    fi
done

# Validar JSON
echo "Validando JSONs..."
echo $LAMBDA_ENV_VARS | jq . > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ LAMBDA_ENV_VARS é um JSON válido"
else
    echo "❌ LAMBDA_ENV_VARS não é um JSON válido"
fi
```

### 8. Limpeza de Recursos

#### Script para cleanup:
```bash
#!/bin/bash

FUNCTION_NAME="lambda-examples-function"
ENVIRONMENT="develop"

echo "Limpando recursos do ambiente $ENVIRONMENT..."

# Remover event source mappings
aws lambda list-event-source-mappings --function-name $FUNCTION_NAME \
  --query 'EventSourceMappings[].UUID' --output text | \
  xargs -I {} aws lambda delete-event-source-mapping --uuid {}

# Remover triggers de S3
aws s3api put-bucket-notification-configuration \
  --bucket lambda-examples-uploads-$ENVIRONMENT \
  --notification-configuration '{}'

# Deletar função Lambda
aws lambda delete-function --function-name $FUNCTION_NAME

echo "Limpeza concluída!"
```

### 9. Contatos e Recursos

- **CloudWatch Logs**: `/aws/lambda/<function-name>`
- **Documentação AWS Lambda**: https://docs.aws.amazon.com/lambda/
- **GitHub Actions Docs**: https://docs.github.com/en/actions
- **Terraform AWS Provider**: https://registry.terraform.io/providers/hashicorp/aws/

### 10. Checklist de Deploy

Antes de fazer deploy, verifique:

- [ ] Environment criado no GitHub com todas as variáveis
- [ ] Credenciais AWS configuradas corretamente
- [ ] Bucket S3 para Terraform state existe
- [ ] Recursos AWS (S3 buckets, SQS queues, etc.) existem
- [ ] Código da Lambda está no diretório correto
- [ ] package.json tem todas as dependencies
- [ ] Testes passando localmente
- [ ] Terraform plan executado sem erros
- [ ] Permissões IAM corretas

### 11. FAQ

**Q: Posso usar layers com este setup?**
A: Sim, adicione a variável `LAMBDA_LAYERS` no environment com ARNs dos layers.

**Q: Como implementar blue-green deployment?**
A: Use aliases e weighted routing. Adicione `LAMBDA_ALIAS_NAME` e `LAMBDA_TRAFFIC_CONFIG` no environment.

**Q: Como configurar VPC?**
A: Configure `LAMBDA_VPC_CONFIG` com subnet_ids e security_group_ids.

**Q: Como usar diferentes runtimes?**
A: Configure `LAMBDA_RUNTIME` no environment (nodejs18.x, python3.9, etc.).

**Q: Como configurar DLQ?**
A: Configure `LAMBDA_DLQ_ARN` no environment com ARN da SQS queue.
