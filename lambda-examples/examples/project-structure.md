# 📁 Estrutura Completa - Lambda Examples

## 🗂️ Visão Geral da Estrutura

```
lambda-examples/
├── 📄 README.md                           # Documentação principal
├── 📄 package.json                        # Dependencies do Node.js
├── 📄 index.js                           # Lambda handler principal
├── .github/
│   └── workflows/
│       └── 📄 deploy.yml                 # Workflow de deploy
└── examples/
    ├── environments/                      # Configurações por environment
    │   ├── 📄 develop.md                 # Configurações develop
    │   ├── 📄 homolog.md                 # Configurações homolog
    │   └── 📄 master.md                  # Configurações master (prod)
    ├── 📄 test-payloads.md              # Exemplos de payloads
    └── 📄 troubleshooting.md            # Guia de troubleshooting
```

## 🔍 Descrição dos Arquivos

### 📁 Raiz do Projeto

- **`README.md`**: Documentação principal com instruções de uso
- **`package.json`**: Configuração do Node.js com dependency do AWS SDK  
- **`index.js`**: Handler principal que detecta e processa todos os tipos de trigger

### 📁 .github/workflows/

- **`deploy.yml`**: Workflow reusável que:
  - Detecta o environment baseado na branch
  - Faz build e upload do código para S3
  - Executa Terraform deploy com configurações específicas do environment
  - Usa GitHub Environments para configurações sensíveis

### 📁 examples/environments/

Configurações detalhadas para cada environment:

- **`develop.md`**: 
  - Timeout: 60s, Memory: 256MB
  - API Gateway IDs: d4c33alv35, vvu27u8aga
  - Configurações básicas para desenvolvimento

- **`homolog.md`**:
  - Timeout: 120s, Memory: 512MB  
  - API Gateway IDs: ytjegz8a4j, 92td23qtud
  - Configurações intermediárias para staging

- **`master.md`**:
  - Timeout: 300s, Memory: 1024MB
  - API Gateway IDs: m31l8hkoch, 4lk2vqj9z0
  - Configurações robustas para produção

### 📁 examples/

- **`test-payloads.md`**: Exemplos práticos de como testar cada trigger:
  - Comandos curl para API Gateway
  - Comandos AWS CLI para S3, SQS, SNS, Kinesis
  - Payloads de exemplo para cada tipo de evento
  - Scripts automatizados de teste

- **`troubleshooting.md`**: Guia completo de resolução de problemas:
  - Erros comuns e soluções
  - Comandos de debug
  - Scripts de validação
  - Checklist de deploy

## 🎯 Funcionalidades Implementadas

### ✅ Triggers Suportados

1. **API Gateway** - Endpoints REST
2. **S3** - Upload/delete de arquivos
3. **SQS** - Processamento de mensagens
4. **SNS** - Notificações
5. **CloudWatch Events** - Tarefas agendadas
6. **CloudWatch Logs** - Monitoramento de logs
7. **Kinesis** - Streaming de dados
8. **Function URL** - Endpoint HTTP direto

### ✅ Configurações por Environment

- **Branch mapping**: develop → homolog → master
- **Configurações escaláveis**: Memory, timeout, log retention
- **Recursos específicos**: API Gateway IDs, buckets, queues
- **Permissões IAM**: Políticas específicas por environment

### ✅ Monitoramento e Debugging

- **CloudWatch Logs** com estrutura padronizada
- **Métricas automáticas** da Lambda
- **Dead Letter Queues** para error handling
- **Scripts de teste** automatizados

## 🚀 Como Usar

### 1. Setup Inicial
```bash
# Clone o exemplo
cp -r lambda-examples/ seu-projeto-lambda/
cd seu-projeto-lambda/

# Customize o código
nano index.js
nano package.json
```

### 2. Configurar GitHub Environments
```bash
# No GitHub: Settings → Environments
# Criar: develop, homolog, master
# Adicionar variáveis conforme examples/environments/
```

### 3. Deploy Automático
```bash
# Push para a branch desejada
git checkout develop
git add .
git commit -m "Deploy para develop"
git push origin develop
```

### 4. Teste dos Triggers
```bash
# Seguir exemplos em test-payloads.md
curl -X POST "https://api-gateway-url/webhook" -d '{"test": true}'
aws s3 cp file.json s3://bucket/incoming/
```

## 🔧 Personalização

### Modificar Triggers
- Edite as variáveis `LAMBDA_*_TRIGGERS` nos environments
- Ajuste ARNs e configurações conforme necessário

### Adicionar Novos Triggers
- Modifique o código em `index.js`
- Adicione configurações nos environments
- Update a documentação

### Customizar Environments
- Adicione novos environments no GitHub
- Crie arquivos de configuração correspondentes
- Ajuste o workflow se necessário

## 📊 Métricas e Monitoramento

### CloudWatch Dashboards
- Invocations, Duration, Errors
- Cold starts, Throttles
- Custom metrics por trigger type

### Alertas Automáticos
- Error rate > threshold
- Duration > timeout warning
- DLQ messages

### Logs Estruturados
```javascript
console.log(JSON.stringify({
  timestamp: new Date().toISOString(),
  level: 'INFO',
  trigger: 'api-gateway',
  requestId: context.awsRequestId,
  message: 'Processing request'
}));
```

## 🔒 Segurança

### IAM Least Privilege
- Permissões específicas por trigger
- Recursos limitados por environment
- Policies documentadas nos environments

### Secrets Management
- AWS Parameter Store integration
- Environment-specific secrets
- Automatic rotation support

### Network Security
- VPC configuration por environment
- Security groups específicos
- Private subnets para recursos sensíveis

## 📈 Escalabilidade

### Performance Tuning
- Reserved concurrency por environment
- Memory otimizada por carga
- Provisioned concurrency para critical paths

### Cost Optimization
- Timeout ajustado por função
- Memory sizing baseado em profiling
- Log retention otimizada

## 🤝 Contribuição

Para contribuir com melhorias:

1. Fork o repositório
2. Crie branch de feature
3. Teste em todos os environments  
4. Update a documentação
5. Submit PR com descrição detalhada

## 📞 Suporte

- **Documentação**: Leia todos os arquivos em `examples/`
- **Issues**: Use o troubleshooting.md primeiro
- **Logs**: Check CloudWatch `/aws/lambda/function-name`
- **Terraform**: Verifique state e plan antes de aplicar
