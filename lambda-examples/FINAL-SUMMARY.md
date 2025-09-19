# ✅ Lambda Examples - Estrutura Final Criada

## 🎯 Resumo do Projeto

Criamos um repositório completo de exemplos para deploy de Lambda functions usando workflows específicos por tipo de trigger, reutilizando o workflow `lambda.yaml` da OrbitSpot.

## 📁 Estrutura Final

```
lambda-examples/
├── 📄 README.md                              # Documentação principal atualizada
├── 📄 package.json                           # Dependencies Node.js
├── 📄 src/index.js                          # Lambda handler multi-trigger
├── .github/workflows/                        # Workflows específicos por trigger
│   ├── 📄 deploy-trigger-apigateway.yml     # Deploy com API Gateway
│   ├── 📄 deploy-trigger-sns.yml            # Deploy com SNS
│   ├── 📄 deploy-trigger-s3.yml             # Deploy com S3
│   ├── 📄 deploy-trigger-sqs.yml            # Deploy com SQS
│   ├── 📄 deploy-trigger-kinesis.yml        # Deploy com Kinesis
│   ├── 📄 deploy-trigger-cloudwatch-events.yml  # Deploy com CloudWatch Events
│   ├── 📄 deploy-trigger-cloudwatch-logs.yml    # Deploy com CloudWatch Logs
│   └── 📄 deploy-trigger-function-url.yml   # Deploy com Function URL
└── examples/                                 # Documentação e exemplos
    ├── environments/                         # Configurações por ambiente
    │   ├── 📄 develop.md                    # Configurações develop
    │   ├── 📄 homolog.md                    # Configurações homolog
    │   └── 📄 master.md                     # Configurações master
    ├── 📄 test-payloads.md                 # Exemplos de payloads
    ├── 📄 troubleshooting.md               # Guia de troubleshooting
    └── 📄 project-structure.md             # Documentação da estrutura
```

## 🔄 Como Funciona

### 1. Workflow Reutilizável
- **Local**: `.github/workflows/lambda.yaml` (já existe no repo OrbitSpot)
- **Função**: Workflow reutilizável que suporta todos os tipos de trigger
- **Parâmetro**: `trigger_type` - define qual trigger configurar

### 2. Workflows Específicos
Cada workflow em `lambda-examples/.github/workflows/` chama o workflow reutilizável:

```yaml
jobs:
  deploy:
    uses: ./.github/workflows/lambda.yaml  # Chama o workflow reutilizável
    with:
      module: "lambda-examples"
      function_name: "lambda-examples-apigateway"  # Nome específico
      trigger_type: "api-gateway"                  # Tipo específico
    secrets: inherit
```

### 3. Lógica de Seleção de Trigger
No workflow `lambda.yaml`, modificamos para usar condicionalmente os triggers:

```yaml
TF_VAR_api_gateway_triggers: ${{ (inputs.trigger_type == 'api-gateway' || inputs.trigger_type == 'all') && vars.LAMBDA_API_GATEWAY_TRIGGERS || '[]' }}
TF_VAR_s3_triggers: ${{ (inputs.trigger_type == 's3' || inputs.trigger_type == 'all') && vars.LAMBDA_S3_TRIGGERS || '[]' }}
# ... e assim por diante para cada tipo
```

## 🌐 Integração com Variáveis da Organização

### Variáveis Já Configuradas (Organization Level)
- **`API_GATEWAY`** - IDs dos API Gateways por ambiente
- **`AWS_ACCOUNT_NUMBER`** - 931670397156
- **`AWS_REGION`** - us-east-1
- **`DEVOPS_CONFIG`** - Configurações de cluster
- **`TERRAFORM_BUCKET`** - terraform-orbit

### Variáveis por Repository (Environment Level)
- **`LAMBDA_TIMEOUT`** - Timeout específico
- **`LAMBDA_MEMORY_SIZE`** - Memória específica
- **`LAMBDA_*_TRIGGERS`** - Triggers específicos por tipo

## 🎯 Tipos de Trigger Suportados

1. **`api-gateway`** - Usa `vars.LAMBDA_API_GATEWAY_TRIGGERS` + `vars.API_GATEWAY`
2. **`s3`** - Usa `vars.LAMBDA_S3_TRIGGERS`
3. **`sns`** - Usa `vars.LAMBDA_SNS_TRIGGERS`
4. **`sqs`** - Usa `vars.LAMBDA_SQS_TRIGGERS`
5. **`kinesis`** - Usa `vars.LAMBDA_KINESIS_TRIGGERS`
6. **`cloudwatch-events`** - Usa `vars.LAMBDA_CLOUDWATCH_EVENT_TRIGGERS`
7. **`cloudwatch-logs`** - Usa `vars.LAMBDA_CLOUDWATCH_LOG_TRIGGERS`
8. **`function-url`** - Força `LAMBDA_FUNCTION_URL_ENABLED=true`
9. **`all`** - Todos os triggers (padrão)

## 🚀 Como Usar

### 1. Copiar para Novo Projeto
```bash
cp -r lambda-examples/ meu-lambda-projeto/
cd meu-lambda-projeto/
```

### 2. Personalizar
```bash
# Editar código da Lambda
nano src/index.js

# Escolher qual workflow usar (ou usar vários)
# Os workflows estão em .github/workflows/deploy-trigger-*.yml
```

### 3. Configurar Environment
```bash
# No GitHub: Settings → Environments
# Criar: develop, homolog, master
# Adicionar apenas as variáveis necessárias para o trigger escolhido
```

### 4. Deploy
```bash
# Push ativa o workflow específico
git push origin develop
```

## ✨ Vantagens desta Abordagem

1. **Reutilização Total**: Um workflow reutilizável para todos os projetos
2. **Flexibilidade**: Cada projeto pode usar triggers específicos
3. **Organização**: Workflows separados por tipo de trigger
4. **Configuração Simples**: Apenas variáveis necessárias por trigger
5. **Padrão OrbitSpot**: Integração com variáveis organizacionais existentes
6. **Escalabilidade**: Fácil adicionar novos tipos de trigger

## 🔧 Manutenção

- **Workflow Central**: Mudanças no `lambda.yaml` afetam todos os projetos
- **Triggers Específicos**: Cada projeto configura apenas o que precisa
- **Versionamento**: Pode usar versões específicas do workflow reutilizável
- **Testing**: Cada trigger pode ser testado independentemente

## 📝 Próximos Passos

1. Testar workflows em diferentes branches
2. Validar com recursos AWS reais
3. Criar templates para novos projetos
4. Documentar patterns de uso avançado
5. Implementar monitoramento e alertas
