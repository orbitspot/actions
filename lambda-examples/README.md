# Lambda Deployment Examples - Trigger-Specific Workflows

Este repositório contém exemplos de workflows específicos para diferentes tipos de triggers do AWS Lambda, utilizando o workflow reutilizável `lambda.yaml` da OrbitSpot.

## 🚀 Workflows Disponíveis

### 1. API Gateway Trigger
**Arquivo:** `deploy-trigger-apigateway.yml`

Configura Lambda com trigger do API Gateway, ideal para APIs REST.

**Configurações personalizáveis:**
- `endpoint`: Endpoint da API (padrão: `/example`)
- `method`: Método HTTP (padrão: `ANY`)

### 2. S3 Trigger
**Arquivo:** `deploy-trigger-s3.yml`

Configura Lambda para ser executado quando objetos são criados/modificados no S3.

**Configurações personalizáveis:**
- `bucket_name`: Nome do bucket S3
- `events`: Tipos de eventos (padrão: `s3:ObjectCreated:*`)
- `filter_prefix`: Prefixo para filtrar objetos
- `filter_suffix`: Sufixo para filtrar objetos (ex: `.jpg`)

### 3. SNS Trigger
**Arquivo:** `deploy-trigger-sns.yml`

Configura Lambda para ser executado quando mensagens são publicadas em tópicos SNS.

**Configurações personalizáveis:**
- `topic_name`: Nome do tópico SNS
- `filter_policy`: Política de filtro para mensagens

### 4. SQS Trigger
**Arquivo:** `deploy-trigger-sqs.yml`

Configura Lambda para processar mensagens de filas SQS.

**Configurações personalizáveis:**
- `queue_name`: Nome da fila SQS
- `batch_size`: Número de mensagens por invocação (1-10000)
- `visibility_timeout`: Timeout de visibilidade em segundos
- `create_queue`: Se deve criar a fila automaticamente

### 5. CloudWatch Events Trigger
**Arquivo:** `deploy-trigger-cloudwatch-events.yml`

Configura Lambda para execução baseada em agenda (cron/rate).

**Configurações personalizáveis:**
- `schedule_expression`: Expressão de agenda
- `rule_name`: Nome da regra
- `rule_description`: Descrição da regra
- `enabled`: Se a regra está ativa

### 6. Kinesis Trigger
**Arquivo:** `deploy-trigger-kinesis.yml`

Configura Lambda para processar registros de streams do Kinesis.

**Configurações personalizáveis:**
- `stream_name`: Nome do stream Kinesis
- `batch_size`: Número de registros por invocação (1-10000)
- `starting_position`: `TRIM_HORIZON` ou `LATEST`
- `parallelization_factor`: Fator de paralelização (1-10)
- `maximum_batching_window`: Janela de agrupamento em segundos

## 📁 Como Usar

### 1. Deploy Automático (Push)
```bash
git push origin develop  # Deploy para desenvolvimento
git push origin homolog  # Deploy para homologação  
git push origin master   # Deploy para produção
```

### 2. Deploy Manual (Workflow Dispatch)
1. Vá para **Actions** no GitHub
2. Selecione o workflow do trigger desejado
3. Clique em **Run workflow**
4. Configure os parâmetros conforme necessário
5. Execute

## 🧪 Exemplos de Teste

### API Gateway
```bash
# Testar endpoint
curl -X POST https://api-id.execute-api.region.amazonaws.com/develop/example \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'
```

### S3 Trigger
```bash
# Upload de arquivo para testar
aws s3 cp test-file.txt s3://lambda-examples-bucket-develop/
```

### SQS Trigger
```bash
# Enviar mensagem
aws sqs send-message \
  --queue-url "https://sqs.region.amazonaws.com/account/queue-name" \
  --message-body '{"test": "message"}'
```

### SNS Trigger
```bash
# Publicar mensagem
aws sns publish \
  --topic-arn "arn:aws:sns:region:account:topic-name" \
  --message '{"test": "notification"}'
```

### Kinesis Trigger
```bash
# Enviar registro
aws kinesis put-record \
  --stream-name "stream-name" \
  --data "$(echo '{"test":"data"}' | base64)" \
  --partition-key "test-partition"
```

## ⚙️ Configuração

### Variáveis de Organização
Configure estas variáveis na organização GitHub:

```
AWS_ROLE_NAME
_AWS_REGION
_DEVOPS_CONFIG
LAMBDA_API_GATEWAY_TRIGGERS
LAMBDA_S3_TRIGGERS
LAMBDA_SNS_TRIGGERS
LAMBDA_SQS_TRIGGERS
LAMBDA_KINESIS_TRIGGERS
LAMBDA_CLOUDWATCH_EVENT_TRIGGERS
```

### Estrutura de Branches
- `master`: Produção
- `homolog`: Homologação
- `develop`: Desenvolvimento

## 🏗️ Arquitetura

Todos os workflows utilizam o padrão:

```yaml
jobs:
  deploy:
    uses: ./.github/workflows/lambda.yaml
    with:
      trigger_type: "[trigger-specific]"
      [trigger]_config: '[]'  # Custom config ou org vars
    secrets: inherit
```

---

**Documentação OrbitSpot:** Estes workflows seguem os padrões da infraestrutura OrbitSpot com branch-environment mapping e integração completa com AWS.

Após o deploy, você pode testar os diferentes triggers:

- **API Gateway**: Fazer requests HTTP para os endpoints
- **S3**: Fazer upload de arquivos nos buckets configurados
- **SQS**: Enviar mensagens para as filas
- **SNS**: Publicar mensagens nos tópicos
- **Scheduler**: Aguardar execução agendada
- **CloudWatch Logs**: Triggers automáticos baseados em logs

## 📋 Triggers Configurados

### API Gateway
- `GET /health` - Health check
- `POST /webhook` - Webhook handler
- `GET /users` - Lista usuários

### S3 Events
- Upload de arquivos (ObjectCreated)
- Remoção de arquivos (ObjectRemoved)

### SQS Messages
- Processamento de mensagens em lote
- Suporte a partial failures

### SNS Notifications  
- Processamento de notificações
- Múltiplos tópicos

### Scheduled Events
- Tarefas diárias
- Limpeza semanal

### CloudWatch Logs
- Monitoramento de erros
- Alertas automáticos

### Kinesis Streams
- Processamento de dados em tempo real

### Function URL
- Endpoint HTTP direto da Lambda

## 🔧 Configuração por Environment

### 📁 Documentação Completa

- **[🔧 Configuração Develop](examples/environments/develop.md)** - Configurações para ambiente de desenvolvimento
- **[🧪 Configuração Homolog](examples/environments/homolog.md)** - Configurações para ambiente de homologação  
- **[🚀 Configuração Master](examples/environments/master.md)** - Configurações para ambiente de produção
- **[🧩 Exemplos de Payloads](examples/test-payloads.md)** - Payloads de teste para cada tipo de trigger
- **[🔧 Troubleshooting](examples/troubleshooting.md)** - Guia de resolução de problemas

### 🚀 Workflows de Deploy

Este projeto inclui workflows específicos para cada tipo de trigger, todos usando o workflow reutilizável `lambda.yaml` da OrbitSpot:

### 📁 Workflows Disponíveis

- **[deploy-trigger-apigateway.yml](.github/workflows/deploy-trigger-apigateway.yml)** - Deploy com trigger API Gateway
- **[deploy-trigger-sns.yml](.github/workflows/deploy-trigger-sns.yml)** - Deploy com trigger SNS
- **[deploy-trigger-s3.yml](.github/workflows/deploy-trigger-s3.yml)** - Deploy com trigger S3
- **[deploy-trigger-sqs.yml](.github/workflows/deploy-trigger-sqs.yml)** - Deploy com trigger SQS
- **[deploy-trigger-kinesis.yml](.github/workflows/deploy-trigger-kinesis.yml)** - Deploy com trigger Kinesis
- **[deploy-trigger-cloudwatch-events.yml](.github/workflows/deploy-trigger-cloudwatch-events.yml)** - Deploy com trigger CloudWatch Events
- **[deploy-trigger-cloudwatch-logs.yml](.github/workflows/deploy-trigger-cloudwatch-logs.yml)** - Deploy com trigger CloudWatch Logs
- **[deploy-trigger-function-url.yml](.github/workflows/deploy-trigger-function-url.yml)** - Deploy com Function URL

### 🔄 Como Funciona

Cada workflow chama o workflow reutilizável `.github/workflows/lambda.yaml` da OrbitSpot passando o parâmetro `trigger_type`:

```yaml
jobs:
  deploy:
    uses: ./.github/workflows/lambda.yaml
    with:
      module: "lambda-examples"
      function_name: "lambda-examples-apigateway"
      handler: "index.handler"
      runtime: "nodejs18.x"
      trigger_type: "api-gateway"  # Define qual trigger configurar
    secrets: inherit
```

### 🎯 Seleção de Trigger

O parâmetro `trigger_type` determina quais triggers serão configurados:

- **`api-gateway`** - Apenas triggers de API Gateway das variáveis `LAMBDA_API_GATEWAY_TRIGGERS`
- **`s3`** - Apenas triggers S3 das variáveis `LAMBDA_S3_TRIGGERS`
- **`sns`** - Apenas triggers SNS das variáveis `LAMBDA_SNS_TRIGGERS`
- **`sqs`** - Apenas triggers SQS das variáveis `LAMBDA_SQS_TRIGGERS`
- **`kinesis`** - Apenas triggers Kinesis das variáveis `LAMBDA_KINESIS_TRIGGERS`
- **`cloudwatch-events`** - Apenas triggers CloudWatch Events das variáveis `LAMBDA_CLOUDWATCH_EVENT_TRIGGERS`
- **`cloudwatch-logs`** - Apenas triggers CloudWatch Logs das variáveis `LAMBDA_CLOUDWATCH_LOG_TRIGGERS`
- **`function-url`** - Apenas Function URL, forçando `LAMBDA_FUNCTION_URL_ENABLED=true`
- **`all`** - Todos os triggers configurados (padrão)

### 🛠️ Personalização

Para criar um novo workflow com trigger específico:

```yaml
name: Deploy Lambda - Meu Trigger

on:
  push:
    branches: [develop, homolog, master]
  workflow_dispatch:

jobs:
  deploy:
    uses: ./.github/workflows/lambda.yaml
    with:
      module: "meu-modulo"
      function_name: "minha-funcao"
      trigger_type: "s3"  # Tipo específico
    secrets: inherit
```

### 📋 Variáveis Principais por Environment

| Environment | Timeout | Memory | Log Level | API Gateway IDs |
|-------------|---------|--------|-----------|-----------------|
| **develop** | 60s | 256MB | debug | d4c33alv35, vvu27u8aga |
| **homolog** | 120s | 512MB | info | ytjegz8a4j, 92td23qtud |
| **master** | 300s | 1024MB | error | m31l8hkoch, 4lk2vqj9z0 |

## 📊 Monitoramento

- **CloudWatch Logs**: `/aws/lambda/lambda-examples-{environment}`
- **CloudWatch Metrics**: Métricas automáticas da Lambda
- **X-Ray Tracing**: Habilitado para rastreamento

## 🧪 Testes

```bash
# Health check
curl https://your-api-gateway-url/health

# Webhook test
curl -X POST https://your-api-gateway-url/webhook \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'

# Function URL test
curl https://your-function-url/
```

## 📁 Estrutura

```
lambda-examples/
├── .github/workflows/deploy.yml    # Workflow de deploy
├── src/index.js                    # Código principal da Lambda
├── examples/                       # Exemplos de configuração
│   ├── environments/              # Configurações por environment
│   └── test-requests/             # Exemplos de requests
├── package.json                   # Dependências Node.js
└── README.md                      # Este arquivo
```

## � Configuração dos Environments

### 🌐 Variáveis da Organização (Já Configuradas)

O sistema utiliza variáveis configuradas em nível de organização OrbitSpot:

- **`API_GATEWAY`** - Configurações dos API Gateways por ambiente
- **`AWS_ACCOUNT_NUMBER`** - Número da conta AWS (931670397156)
- **`AWS_REGION`** - Região padrão (us-east-1)
- **`AWS_ROLE_NAME`** - Role para GitHub Actions (github-actions)
- **`DEVOPS_CONFIG`** - Configurações de cluster por ambiente
- **`TERRAFORM_BUCKET`** - Bucket para Terraform state (terraform-orbit)

### 📋 Variáveis por Environment (Repository Level)

Configure estas variáveis nos GitHub Environments do seu repositório:

#### 🔧 Configurações Básicas da Lambda
```
LAMBDA_TIMEOUT=60                    # Timeout em segundos
LAMBDA_MEMORY_SIZE=256               # Memória em MB
LAMBDA_LOG_RETENTION=14              # Retenção de logs em dias
LAMBDA_RESERVED_CONCURRENCY=-1       # Concorrência reservada (-1 = sem limite)
```

#### 🌍 Variáveis de Ambiente da Lambda
```json
LAMBDA_ENV_VARS={"NODE_ENV":"development","LOG_LEVEL":"debug","ENVIRONMENT":"develop"}
```

#### 🎯 Configuração de Triggers (por tipo)

Apenas configure as variáveis do tipo de trigger que você está usando:

**API Gateway:**
```json
LAMBDA_API_GATEWAY_TRIGGERS=[{"api_id":"d4c33alv35","resource_id":"h0ebgzn072","http_method":"GET","path":"/health"}]
```

**S3:**
```json
LAMBDA_S3_TRIGGERS=[{"bucket_name":"my-bucket-develop","events":["s3:ObjectCreated:*"],"filter_prefix":"incoming/"}]
```

**SNS:**
```json
LAMBDA_SNS_TRIGGERS=["arn:aws:sns:us-east-1:931670397156:my-topic-develop"]
```

**SQS:**
```json
LAMBDA_SQS_TRIGGERS=[{"queue_arn":"arn:aws:sqs:us-east-1:931670397156:my-queue-develop","batch_size":10}]
```

#### 🔗 Function URL (opcional)
```
LAMBDA_FUNCTION_URL_ENABLED=true
LAMBDA_FUNCTION_URL_AUTH_TYPE=AWS_IAM
LAMBDA_FUNCTION_URL_CORS={"allow_origins":["*"],"allow_methods":["GET","POST"]}
```

### 🚀 Setup Rápido

1. **Configure o Environment no GitHub:**
   ```bash
   # No GitHub: Settings → Environments
   # Criar: develop, homolog, master
   ```

2. **Adicione apenas as variáveis necessárias:**
   - Configure apenas `LAMBDA_*_TRIGGERS` do tipo que você está usando
   - As variáveis da organização já estão configuradas
   - Use os guias em `examples/environments/` como referência

3. **Execute o workflow específico:**
   ```bash
   # Push ativa apenas o workflow correspondente ao trigger
   git push origin develop
   ```

### 📁 Documentação Completa

- **[🔧 Configuração Develop](examples/environments/develop.md)** - Configurações para ambiente de desenvolvimento
- **[🧪 Configuração Homolog](examples/environments/homolog.md)** - Configurações para ambiente de homologação  
- **[🚀 Configuração Master](examples/environments/master.md)** - Configurações para ambiente de produção
- **[🧩 Exemplos de Payloads](examples/test-payloads.md)** - Payloads de teste para cada tipo de trigger
- **[🔧 Troubleshooting](examples/troubleshooting.md)** - Guia de resolução de problemas

## �🔐 Segurança

- Autenticação via Custom Authorizer nos API Gateways
- IAM roles específicas por environment
- Logs com informações sensíveis mascaradas
- CORS configurado adequadamente

## 🚨 Troubleshooting

### Lambda não executa
1. Verificar logs no CloudWatch
2. Confirmar IAM permissions
3. Validar configuração dos triggers

### API Gateway retorna 403
1. Verificar Custom Authorizer
2. Confirmar configuração de CORS
3. Validar token de autenticação

### Mensagens SQS não processam
1. Verificar Dead Letter Queue
2. Confirmar batch size
3. Validar timeout da Lambda
