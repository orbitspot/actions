# Análise: Mudanças Necessárias para Suportar Múltiplas Contas AWS

## 🎯 Contexto
Antes: 3 ambientes (develop, homolog, master) na mesma conta AWS (931670397156)
Agora: Ambiente de teste em conta separada (883229995409)
Objetivo: Workflows reutilizáveis devem funcionar em qualquer conta AWS

## ✅ Já Implementado
- [x] AWS_ACCOUNT_NUMBER dinâmico baseado na branch via `_AWS_ACCOUNT_NUMBER`
- [x] Todos os workflows atualizados para usar `needs.setup-config.outputs.AWS_ACCOUNT_NUMBER`

## 🔧 Mudanças Necessárias

### 1. **Buckets S3 (CRÍTICO)** 
❌ **Problema**: Referências hardcoded a buckets S3 na conta principal

**Arquivos Afetados**:
- `.github/actions/generate-docker/action.yaml` (3 ocorrências)
- `.github/actions/docker/action.yml` (1 ocorrência)  
- `.github/actions/kubernetes-auth/action.yml` (1 ocorrência)
- `.github/workflows/node_frontend.yaml` (1 ocorrência)
- `.github/workflows/node_landingpage.yaml` (1 ocorrência)

**Referências Hardcoded**:
```bash
s3://devops.orbitspot.com/build-github-actions/
s3://devops.orbitspot.com/charts/
```

**Soluções Possíveis**:

#### Opção A: Criar variável `_S3_DEVOPS_BUCKET` (Recomendado)
```json
{
  "develop": {"S3_DEVOPS_BUCKET": "devops.orbitspot.com"},
  "homolog": {"S3_DEVOPS_BUCKET": "devops.orbitspot.com"},
  "master": {"S3_DEVOPS_BUCKET": "devops.orbitspot.com"},
  "test": {"S3_DEVOPS_BUCKET": "devops-test.orbitspot.com"}
}
```

#### Opção B: Replicar conteúdo do bucket S3
Copiar conteúdo necessário de `s3://devops.orbitspot.com` para bucket na nova conta:
- `/build-github-actions/v1/node/*/Dockerfile`
- `/build-github-actions/v1/scripts/base_script.sh`
- `/build-github-actions/v1/ecr/ecr-policy.json`
- `/build-github-actions/v1/deploy/frontend/`
- `/build-github-actions/v1/deploy/landingpage/`
- `/charts/`

#### Opção C: S3 Cross-Account Access (Mais complexo)
Configurar políticas de bucket para permitir acesso cross-account.

---

### 2. **Terraform State Buckets**
⚠️ **Problema Potencial**: Backend do Terraform pode estar na conta principal

**Arquivos que referenciam**:
- `.github/actions/parameter-store/action.yaml`
- `.github/actions/api-gateway/action.yaml`
- `.github/actions/terraform-init/action.yaml`
- `.github/actions/terraform-plan/action.yaml`
- `.github/actions/terraform-apply/action.yaml`

**Todas usam**: `terraform_bucket_name` como input (já parametrizado ✅)

**Ação Necessária**:
- Verificar se a variável `TERRAFORM_BUCKET` existe em `_DEVOPS_CONFIG`
- Se não existir, adicionar mapeamento similar ao AWS_ACCOUNT_NUMBER

Exemplo de estrutura em `_DEVOPS_CONFIG`:
```json
{
  "develop": {
    "TERRAFORM_BUCKET": "terraform-state-main",
    "CLUSTER_NAME": "...",
    ...
  },
  "test": {
    "TERRAFORM_BUCKET": "terraform-state-test-account",
    "CLUSTER_NAME": "...",
    ...
  }
}
```

---

### 3. **ECR (Elastic Container Registry)**
✅ **OK**: Já está usando `AWS_ACCOUNT_NUMBER` dinamicamente

```yaml
# Exemplo em node_api.yaml
--set 'containers[0].repository.image=${{ needs.setup-config.outputs.AWS_ACCOUNT_NUMBER }}.dkr.ecr.${{ env.CLUSTER_REGION }}.amazonaws.com/...'
```

**Verificar**:
- ECR repositories existem na nova conta test
- Lifecycle policies configuradas
- Permissões de pull/push corretas

---

### 4. **IAM Roles**
✅ **OK**: Roles já usam `AWS_ACCOUNT_NUMBER` dinâmico

**Verificações Necessárias na Conta Test**:

#### a) Role para GitHub Actions
```
arn:aws:iam::883229995409:role/<AWS_ROLE_NAME>
```
- Trust policy com GitHub OIDC provider configurado
- Permissões: ECR, EKS, S3, Parameter Store, Terraform

#### b) Roles para Service Accounts (IRSA)
```
arn:aws:iam::883229995409:role/<repo-name>-<env>
```
**Criados por**: `.github/actions/create-role-service-account/action.yaml`

**Verificar**:
- Trust policy aponta para OIDC provider correto do cluster test
- Permissões adequadas (S3, RDS, SQS, etc)

---

### 5. **EKS Clusters**
⚠️ **Verificar**: Configurações do cluster na nova conta

**Verificações**:
- Cluster existe e está acessível
- OIDC provider configurado para IRSA
- Node groups com capacidade
- VPC/Subnets configuradas
- Security groups
- kubectl access configurado via IAM role

**Variáveis relacionadas** (vindas de `_DEVOPS_CONFIG`):
- `CLUSTER_NAME`
- `CLUSTER_REGION`

---

### 6. **Configurações de Ambiente Específicas**

#### a) CodeArtifact
**Arquivo**: `.github/actions/code-artifact-authenticate/action.yml`

Verificar se CodeArtifact existe na conta test ou se deve usar da conta principal (pode ser cross-account).

#### b) Parameter Store
**Arquivo**: `.github/actions/parameter-store/action.yaml`

Parâmetros do Systems Manager devem existir na conta test.

#### c) Secrets Manager
Se algum workflow usa Secrets Manager, verificar na conta test.

---

### 7. **Variáveis de Ambiente do GitHub**

**Variáveis por Ambiente** (develop, homolog, master, test):

Variável `_DEVOPS_CONFIG` deve ter configuração completa para "test":
```json
{
  "test": {
    "CLUSTER_NAME": "test-cluster",
    "CLUSTER_REGION": "us-east-1",
    "ACM_ARN": "arn:aws:acm:...",
    "ENV": "test",
    "TERRAFORM_BUCKET": "terraform-state-test",
    "API_HOST": "api-test.domain.com",
    "ISTIO_HOST": "test.domain.com",
    "DB_HOST": "test-db.rds.amazonaws.com",
    "DB_PORT": "5432"
  }
}
```

**Variáveis Globais**:
- `AWS_ROLE_NAME` - Nome da role de deploy (pode ser diferente por conta)
- `_AWS_REGION` - Pode ser diferente por ambiente
- `_API_GATEWAY` - Configurações do API Gateway
- `_POLICY_JSON` - Políticas IAM (pode variar por conta)

---

## 📋 Checklist de Implementação

### Alta Prioridade (Bloqueadores)
- [ ] **1. Resolver buckets S3** - Escolher e implementar Opção A, B ou C
- [ ] **2. Criar IAM roles na conta test**
  - [ ] Role principal do GitHub Actions
  - [ ] Configurar trust policy com GitHub OIDC
  - [ ] Adicionar permissões necessárias
- [ ] **3. Configurar `_DEVOPS_CONFIG` para ambiente test**
- [ ] **4. Verificar/criar EKS cluster na conta test**
  - [ ] OIDC provider configurado
  - [ ] Node groups funcionando

### Média Prioridade
- [ ] **5. Criar repositórios ECR na conta test**
- [ ] **6. Configurar Terraform state bucket na conta test**
- [ ] **7. Verificar CodeArtifact** (ou configurar acesso cross-account)
- [ ] **8. Criar parâmetros no Parameter Store da conta test**

### Baixa Prioridade (Validações)
- [ ] **9. Testar deploy completo no ambiente test**
- [ ] **10. Documentar diferenças entre contas**
- [ ] **11. Criar runbook para onboarding de novas contas**

---

## 🚀 Recomendação de Implementação

### Fase 1: Infraestrutura Base (1-2 dias)
1. Criar role IAM principal na conta test
2. Criar cluster EKS (ou validar existente)
3. Configurar OIDC provider

### Fase 2: Dados e Configurações (1 dia)
4. **Decisão crítica**: Escolher solução para S3 buckets
5. Implementar solução escolhida
6. Criar buckets Terraform state
7. Configurar `_DEVOPS_CONFIG` para test

### Fase 3: Actions e Workflows (2-3 horas)
8. Se Opção A escolhida para S3: Atualizar actions para usar variável dinâmica
9. Testar workflows em branch test

### Fase 4: Validação (1 dia)
10. Deploy de teste end-to-end
11. Validar todos os componentes
12. Documentar procedimentos

---

## 💡 Sugestão: Tornar Tudo Parametrizável

Para facilitar futuras adições de contas/ambientes:

### Criar variável `_INFRASTRUCTURE_CONFIG`:
```json
{
  "develop": {
    "AWS_ACCOUNT_NUMBER": "931670397156",
    "S3_DEVOPS_BUCKET": "devops.orbitspot.com",
    "TERRAFORM_BUCKET": "terraform-orbit",
    "AWS_ROLE_NAME": "github-actions-deploy",
    "CODEARTIFACT_DOMAIN": "orbitspot",
    "CODEARTIFACT_REPOSITORY": "npm-store"
  },
  "test": {
    "AWS_ACCOUNT_NUMBER": "883229995409",
    "S3_DEVOPS_BUCKET": "devops-test.orbitspot.com",
    "TERRAFORM_BUCKET": "terraform-orbit-test",
    "AWS_ROLE_NAME": "github-actions-deploy-test",
    "CODEARTIFACT_DOMAIN": "orbitspot-test",
    "CODEARTIFACT_REPOSITORY": "npm-store-test"
  }
}
```

Isso centralizaria TODAS as configurações específicas de infraestrutura em um único lugar.

---

## ⚠️ Riscos e Mitigações

| Risco | Impacto | Mitigação |
|-------|---------|-----------|
| S3 buckets inacessíveis na nova conta | ALTO - Workflows falham | Implementar Opção A ou replicar dados |
| Roles IAM não configuradas | ALTO - Sem autenticação | Criar roles antes de testar |
| ECR repos não existem | MÉDIO - Build falha | Action cria automaticamente (já implementado) |
| Cluster EKS diferente | MÉDIO - Deploy falha | Validar CLUSTER_NAME em _DEVOPS_CONFIG |
| Parâmetros SSM faltando | MÉDIO - Runtime falha | Migrar parâmetros necessários |

---

## 📞 Próximos Passos Recomendados

1. **Decisão**: Qual solução para buckets S3? (Opção A, B ou C?)
2. **Validar**: Quais recursos já existem na conta test?
3. **Priorizar**: Qual ambiente test será usado primeiro?
4. **Implementar**: Começar pela infraestrutura base (IAM, EKS)
