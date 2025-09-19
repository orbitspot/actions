# Guia de Uso do Workflow Lambda

Este guia mostra como usar o workflow reutilizável de Lambda para fazer deploy de funções Lambda a partir de repositórios de código.

## Configuração dos Environments no GitHub

### 1. Criação dos Environments

No repositório da sua Lambda function, configure os environments:

**Settings → Environments → New environment**

Crie 3 environments:
- `develop` - Ambiente de desenvolvimento
- `homolog` - Ambiente de homologação
- `master` - Ambiente de produção

### 2. Variáveis por Environment

Configure as seguintes variáveis em cada environment (Settings → Environments → [nome] → Environment variables):

#### **Environment Variables Básicas:**
```
# Configurações da Lambda
LAMBDA_TIMEOUT=30                    # develop: 30, homolog: 60, master: 300
LAMBDA_MEMORY_SIZE=256              # develop: 256, homolog: 512, master: 1024
LAMBDA_LOG_RETENTION=14             # develop: 7, homolog: 14, master: 30
LAMBDA_RESERVED_CONCURRENCY=-1      # develop: -1, homolog: 5, master: 10

# Variáveis de ambiente da Lambda (JSON)
LAMBDA_ENV_VARS={"NODE_ENV":"development","LOG_LEVEL":"debug"}

# Configuração VPC (JSON ou 'null')
LAMBDA_VPC_CONFIG=null

# Permissões IAM específicas (JSON array)
LAMBDA_IAM_POLICIES=[]

# Dead Letter Queue (ARN ou vazio)
LAMBDA_DLQ_ARN=

# Function URL
LAMBDA_FUNCTION_URL_ENABLED=false
LAMBDA_FUNCTION_URL_AUTH_TYPE=AWS_IAM
LAMBDA_FUNCTION_URL_CORS=null
```

#### **Triggers por Environment (JSON arrays):**
```
# API Gateway triggers
LAMBDA_API_GATEWAY_TRIGGERS=[]

# S3 triggers
LAMBDA_S3_TRIGGERS=[{"bucket_name":"my-bucket-develop","events":["s3:ObjectCreated:*"],"filter_prefix":"uploads/"}]

# SQS triggers
LAMBDA_SQS_TRIGGERS=[{"queue_arn":"arn:aws:sqs:us-east-1:123456789012:queue-develop","batch_size":5}]

# SNS triggers
LAMBDA_SNS_TRIGGERS=["arn:aws:sns:us-east-1:123456789012:topic-develop"]

# DynamoDB triggers
LAMBDA_DYNAMODB_TRIGGERS=[]

# Kinesis triggers  
LAMBDA_KINESIS_TRIGGERS=[]

# CloudWatch Events (cron jobs)
LAMBDA_CLOUDWATCH_EVENT_TRIGGERS=[{"rule_name":"daily-task","schedule_expression":"cron(0 10 * * ? *)","enabled":true}]

# CloudWatch Logs triggers
LAMBDA_CLOUDWATCH_LOG_TRIGGERS=[]

# Cognito triggers
LAMBDA_COGNITO_TRIGGERS=[]

# ALB triggers
LAMBDA_ALB_TRIGGERS=[]
```

### 3. Exemplos de Configuração por Environment

#### **Environment: develop**
```bash
# Configurações básicas
LAMBDA_TIMEOUT=30
LAMBDA_MEMORY_SIZE=256
LAMBDA_LOG_RETENTION=7
LAMBDA_RESERVED_CONCURRENCY=-1

# Variáveis de ambiente
LAMBDA_ENV_VARS={"NODE_ENV":"development","LOG_LEVEL":"debug","API_URL":"https://dev-api.example.com"}

# Triggers para desenvolvimento
LAMBDA_S3_TRIGGERS=[{"bucket_name":"uploads-develop","events":["s3:ObjectCreated:*"],"filter_prefix":"incoming/"}]
LAMBDA_SQS_TRIGGERS=[{"queue_arn":"arn:aws:sqs:us-east-1:123456789012:processing-develop","batch_size":5,"enabled":true}]
LAMBDA_SNS_TRIGGERS=["arn:aws:sns:us-east-1:123456789012:notifications-develop"]

# Function URL habilitada para testes
LAMBDA_FUNCTION_URL_ENABLED=true
LAMBDA_FUNCTION_URL_AUTH_TYPE=NONE
LAMBDA_FUNCTION_URL_CORS={"allow_credentials":false,"allow_headers":["content-type"],"allow_methods":["GET","POST"],"allow_origins":["*"],"max_age":3600}
```

#### **Environment: homolog**  
```bash
# Configurações intermediárias
LAMBDA_TIMEOUT=60
LAMBDA_MEMORY_SIZE=512
LAMBDA_LOG_RETENTION=14
LAMBDA_RESERVED_CONCURRENCY=5

# Variáveis de ambiente
LAMBDA_ENV_VARS={"NODE_ENV":"staging","LOG_LEVEL":"info","API_URL":"https://staging-api.example.com"}

# Triggers para homologação
LAMBDA_S3_TRIGGERS=[{"bucket_name":"uploads-homolog","events":["s3:ObjectCreated:*"],"filter_prefix":"incoming/"}]
LAMBDA_SQS_TRIGGERS=[{"queue_arn":"arn:aws:sqs:us-east-1:123456789012:processing-homolog","batch_size":10,"enabled":true}]
LAMBDA_SNS_TRIGGERS=["arn:aws:sns:us-east-1:123456789012:notifications-homolog"]

# Scheduled trigger para relatórios de teste
LAMBDA_CLOUDWATCH_EVENT_TRIGGERS=[{"rule_name":"test-report","schedule_expression":"cron(0 9 * * ? *)","enabled":true}]

# Function URL com autenticação
LAMBDA_FUNCTION_URL_ENABLED=true  
LAMBDA_FUNCTION_URL_AUTH_TYPE=AWS_IAM
LAMBDA_FUNCTION_URL_CORS={"allow_credentials":true,"allow_headers":["content-type","authorization"],"allow_methods":["GET","POST"],"allow_origins":["https://staging.example.com"],"max_age":3600}
```

#### **Environment: master**
```bash
# Configurações de produção
LAMBDA_TIMEOUT=300
LAMBDA_MEMORY_SIZE=1024
LAMBDA_LOG_RETENTION=30
LAMBDA_RESERVED_CONCURRENCY=20

# Variáveis de ambiente
LAMBDA_ENV_VARS={"NODE_ENV":"production","LOG_LEVEL":"warn","API_URL":"https://api.example.com"}

# Triggers de produção
LAMBDA_S3_TRIGGERS=[{"bucket_name":"uploads-production","events":["s3:ObjectCreated:*"],"filter_prefix":"incoming/","filter_suffix":".json"}]
LAMBDA_SQS_TRIGGERS=[{"queue_arn":"arn:aws:sqs:us-east-1:123456789012:processing-production","batch_size":20,"maximum_batching_window_in_seconds":10,"enabled":true}]
LAMBDA_SNS_TRIGGERS=["arn:aws:sns:us-east-1:123456789012:notifications-production","arn:aws:sns:us-east-1:123456789012:alerts-production"]

# DLQ para tratamento de erros
LAMBDA_DLQ_ARN=arn:aws:sqs:us-east-1:123456789012:lambda-dlq-production

# Scheduled triggers para produção
LAMBDA_CLOUDWATCH_EVENT_TRIGGERS=[{"rule_name":"daily-report","schedule_expression":"cron(0 8 * * ? *)","enabled":true},{"rule_name":"weekly-cleanup","schedule_expression":"cron(0 2 ? * SUN *)","enabled":true}]

# Permissões IAM específicas para produção
LAMBDA_IAM_POLICIES=[{"Effect":"Allow","Action":["s3:GetObject","s3:PutObject"],"Resource":["arn:aws:s3:::uploads-production/*","arn:aws:s3:::processed-production/*"]},{"Effect":"Allow","Action":["sns:Publish"],"Resource":["arn:aws:sns:us-east-1:123456789012:*-production"]}]

# Function URL desabilitada em produção (usar API Gateway)
LAMBDA_FUNCTION_URL_ENABLED=false
```

### 4. Repository Variables Globais

Configure essas variáveis a nível de repositório (Settings → Secrets and variables → Actions → Variables):

```bash
# Variáveis globais do OrbitSpot
AWS_ROLE_NAME=your-lambda-role
_AWS_REGION=us-east-1
_DEVOPS_CONFIG=your-devops-config
AWS_ACCOUNT_NUMBER=123456789012
```

## Configuração Básica no Repositório da Lambda

### 1. Estrutura do Repositório

```
my-lambda-repo/
├── .github/
│   └── workflows/
│       └── deploy.yml          # Workflow que chama o reutilizável
├── src/
│   ├── index.js               # Código principal da Lambda
│   └── utils/
│       └── helpers.js
├── tests/
│   └── index.test.js
├── package.json
├── requirements.txt           # Para Python
├── Dockerfile.lambda         # Para build com Docker (opcional)
├── lambda-config.tf          # Configuração específica da Lambda
└── README.md
```

### 2. Exemplo de Workflow de Deploy (.github/workflows/deploy.yml)

**Workflow Simples (usa configuração dos environments):**

```yaml
name: Deploy Lambda Function

on:
  push:
    branches: [develop, homolog, master]
  pull_request:
    branches: [develop, homolog, master]

jobs:
  deploy:
    # Só faz deploy em push para as branches principais
    if: github.event_name == 'push'
    uses: orbitspot/actions/.github/workflows/lambda.yaml@v20.8.0
    with:
      module: 'my-lambda-service'
      handler: 'src/index.handler'
      runtime: 'nodejs18.x'
      # timeout e memory_size serão sobrescritos pelas variáveis do environment
      timeout: 30                      # Fallback se não definido no environment
      memory_size: 256                 # Fallback se não definido no environment
      build_command: 'npm run build'
      source_dir: '.'
      node_version: '18'
    secrets: inherit
```

**Workflow com Override de Configurações:**

```yaml
name: Deploy Lambda Function

on:
  push:
    branches: [develop, homolog, master]

jobs:
  deploy:
    if: github.event_name == 'push'
    uses: orbitspot/actions/.github/workflows/lambda.yaml@v20.8.0
    with:
      module: 'my-lambda-service'
      function_name: 'custom-function-name'  # Override do nome padrão
      handler: 'src/index.handler'
      runtime: 'nodejs18.x'
      timeout: 30                            # Será sobrescrito pelo environment
      memory_size: 256                       # Será sobrescrito pelo environment
      build_command: 'npm ci && npm run build && npm prune --production'
      package_command: 'zip -r function.zip . -x "node_modules/.bin/*" "tests/*" "*.test.*" ".git*"'
      source_dir: '.'
      exclude_files: 'tests/ *.test.js .git/ .github/ README.md docs/'
      node_version: '18'
    secrets: inherit
```

### 3. Exemplo para Lambda Python

```yaml
name: Deploy Python Lambda

on:
  push:
    branches: [develop, homolog, master]

jobs:
  deploy:
    if: github.event_name == 'push'
    uses: orbitspot/actions/.github/workflows/lambda.yaml@v20.8.0
    with:
      module: 'data-processor'
      handler: 'app.lambda_handler'
      runtime: 'python3.9'
      timeout: 300
      memory_size: 512
      build_command: 'pip install -r requirements.txt -t .'
      package_command: 'zip -r function.zip . -x "tests/*" "*.pyc" "__pycache__/*"'
      source_dir: 'src'
    secrets: inherit
```

### 4. Exemplo com Build Docker

```yaml
name: Deploy Lambda with Docker

on:
  push:
    branches: [develop, homolog, master]

jobs:
  deploy:
    if: github.event_name == 'push'
    uses: orbitspot/actions/.github/workflows/lambda.yaml@v20.8.0
    with:
      module: 'complex-lambda'
      handler: 'app.handler'
      runtime: 'python3.9'
      timeout: 600
      memory_size: 1024
      use_docker_build: true
      docker_file: 'Dockerfile.lambda'
    secrets: inherit
```

## Monitoramento e Debugging

### 1. Logs do CloudWatch

O workflow automaticamente cria um log group para cada Lambda:
- **Nome**: `/aws/lambda/{function-name}`
- **Retenção**: Configurada via `LAMBDA_LOG_RETENTION` por environment

### 2. Outputs do Workflow

O workflow retorna informações úteis:
```yaml
outputs:
  function_name: ${{ steps.lambda-outputs.outputs.function_name }}
  function_arn: ${{ steps.lambda-outputs.outputs.function_arn }}
  function_url: ${{ steps.lambda-outputs.outputs.function_url }}
```

### 3. Debugging Common Issues

**Lambda não recebe triggers:**
- Verifique se os ARNs dos recursos estão corretos nos environments
- Confirme se as permissões IAM estão configuradas

**Build falha:**
- Verifique se `build_command` está correto para seu projeto
- Confirme se todas as dependências estão no `package.json` ou `requirements.txt`

**Timeout em produção:**
- Ajuste `LAMBDA_TIMEOUT` no environment master
- Considere otimizar o código ou aumentar `LAMBDA_MEMORY_SIZE`

## Resumo do Fluxo com Environments

### **Fluxo Completo:**
1. **Push para branch** → Trigger automático do workflow
2. **Environment Selection** → GitHub seleciona environment baseado na branch
3. **Load Environment Config** → Carrega variáveis específicas do environment
4. **Build da Lambda** → Instala dependências e cria package
5. **Upload para S3** → Package versionado por commit SHA
6. **Deploy Terraform** → Aplica infraestrutura com configuração do environment
7. **Configure Triggers** → Cria triggers baseados nas variáveis do environment
8. **Update Code** → Atualiza função com novo package

### **Vantagens desta Abordagem:**
- ✅ **Configuração centralizada** por environment no GitHub
- ✅ **Sem código Terraform** nos repositórios de Lambda  
- ✅ **Fácil manutenção** - mudanças de config via UI do GitHub
- ✅ **Segurança** - Secrets e variáveis isoladas por environment
- ✅ **Consistência** - Mesmo workflow para todas as Lambdas
- ✅ **Rollback simples** - Reverter variáveis de environment

### **Estrutura Final:**
```
my-lambda-repo/
├── .github/workflows/deploy.yml    # Workflow simples que chama o reutilizável
├── src/index.js                    # Código da Lambda
├── package.json                    # Dependências
└── README.md                       # Documentação

# GitHub Environments:
# - develop: Configurações de dev
# - homolog: Configurações de staging  
# - master: Configurações de produção
```

Este setup permite máxima flexibilidade com mínima complexidade! 🚀

## Exemplos de Código Lambda

### 1. Lambda Node.js para processamento SQS

```javascript
// src/index.js
const AWS = require('aws-sdk');

exports.handler = async (event) => {
    console.log('Received event:', JSON.stringify(event, null, 2));
    
    // Processar mensagens SQS
    for (const record of event.Records) {
        try {
            const message = JSON.parse(record.body);
            await processMessage(message);
            
            // Mensagem processada com sucesso
            console.log('Processed message:', record.messageId);
        } catch (error) {
            console.error('Error processing message:', error);
            throw error; // Vai para DLQ se configurado
        }
    }
    
    return {
        statusCode: 200,
        batchItemFailures: [] // Retorna lista vazia se todos processaram com sucesso
    };
};

async function processMessage(message) {
    // Lógica de processamento aqui
    console.log('Processing:', message);
    
    // Exemplo: salvar em outro serviço, enviar para SNS, etc.
    return { processed: true };
}
```

### 2. Lambda Python para processamento S3

```python
# app.py
import json
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_client = boto3.client('s3')
sns_client = boto3.client('sns')

def lambda_handler(event, context):
    logger.info(f"Received event: {json.dumps(event)}")
    
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        
        try:
            # Processar arquivo do S3
            result = process_s3_file(bucket, key)
            
            # Notificar sucesso via SNS
            notify_processing_result(result, success=True)
            
        except Exception as e:
            logger.error(f"Error processing {bucket}/{key}: {str(e)}")
            notify_processing_result({'error': str(e)}, success=False)
            raise
    
    return {
        'statusCode': 200,
        'body': json.dumps('Processing completed')
    }

def process_s3_file(bucket, key):
    # Baixar e processar arquivo
    response = s3_client.get_object(Bucket=bucket, Key=key)
    content = response['Body'].read()
    
    # Processar conteúdo
    data = json.loads(content)
    
    # Salvar resultado processado
    result_key = key.replace('incoming/', 'processed/')
    s3_client.put_object(
        Bucket=bucket.replace('uploads', 'processed'),
        Key=result_key,
        Body=json.dumps(data)
    )
    
    return {'file': key, 'records': len(data)}

def notify_processing_result(result, success=True):
    topic_arn = os.environ.get('SNS_TOPIC_ARN')
    if topic_arn:
        sns_client.publish(
            TopicArn=topic_arn,
            Message=json.dumps(result),
            Subject=f"File processing {'succeeded' if success else 'failed'}"
        )
```

## Package.json para Lambda Node.js

```json
{
  "name": "my-lambda-function",
  "version": "1.0.0",
  "description": "Lambda function for order processing",
  "main": "src/index.js",
  "scripts": {
    "build": "npm ci --only=production",
    "test": "jest",
    "local": "sam local start-api"
  },
  "dependencies": {
    "aws-sdk": "^2.1400.0"
  },
  "devDependencies": {
    "jest": "^29.0.0"
  }
}
```

## Dockerfile.lambda (para builds complexas)

```dockerfile
FROM public.ecr.aws/lambda/python:3.9

# Copiar requirements
COPY requirements.txt ${LAMBDA_TASK_ROOT}

# Instalar dependências
RUN pip install -r requirements.txt

# Copiar código da aplicação
COPY src/ ${LAMBDA_TASK_ROOT}

# Definir handler
CMD ["app.lambda_handler"]
```

## Variáveis de Ambiente Necessárias

Configure estas variáveis no seu repositório de Lambda (Settings > Secrets and variables > Actions):

### Repository Variables
- `AWS_ROLE_NAME`: Nome da role IAM para assumir
- `_AWS_REGION`: Região AWS padrão
- `_DEVOPS_CONFIG`: Configuração do DevOps
- `AWS_ACCOUNT_NUMBER`: Número da conta AWS

### Repository Secrets
Configure os secrets necessários para sua aplicação específica.

## Resumo do Fluxo

1. **Push para branch** → Trigger do workflow
2. **Build da Lambda** → Instala dependências e cria package
3. **Upload para S3** → Package é enviado para S3
4. **Deploy Terraform** → Usa o módulo Lambda com configuração específica
5. **Update código** → Atualiza função com novo package
6. **Outputs** → Retorna informações da função criada

Este setup permite que cada repositório de Lambda tenha sua própria configuração de triggers e permissões, enquanto usa o workflow e módulo Terraform reutilizáveis.
