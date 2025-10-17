# Get AWS Account Number Action

Action reutilizável que seleciona o AWS Account Number apropriado baseado na branch atual do repositório.

## Descrição

Esta action elimina a necessidade de configurar manualmente `AWS_ACCOUNT_NUMBER` como variável de ambiente em cada workflow. Ela determina automaticamente o número da conta AWS baseado na branch:

- **develop, homolog, master** → `931670397156`
- **test** → `883229995409`

## Outputs

| Nome | Descrição |
|------|-----------|
| `account-number` | O AWS Account Number para a branch atual |

## Exemplo de Uso

### Uso Básico em um Job

```yaml
jobs:
  get-aws-account:
    name: Get AWS Account Number
    runs-on: ubuntu-latest
    outputs:
      account-number: ${{ steps.get-account.outputs.account-number }}
    steps:
      - name: Get AWS Account Number
        id: get-account
        uses: orbitspot/actions/.github/actions/get-aws-account-number@v21
```

### Uso em Workflow Completo

```yaml
jobs:
  get-aws-account:
    name: Get AWS Account Number
    runs-on: ubuntu-latest
    outputs:
      account-number: ${{ steps.get-account.outputs.account-number }}
    steps:
      - name: Get AWS Account Number
        id: get-account
        uses: orbitspot/actions/.github/actions/get-aws-account-number@v21

  setup-config:
    name: Set Up Config
    runs-on: ubuntu-latest
    needs: [get-aws-account]
    outputs:
      AWS_ACCOUNT_NUMBER: ${{ needs.get-aws-account.outputs.account-number }}
    steps:
      # ... seus steps aqui

  deploy:
    name: Deploy
    runs-on: ubuntu-latest
    needs: [setup-config]
    env:
      AWS_ACCOUNT_NUMBER: ${{ needs.setup-config.outputs.AWS_ACCOUNT_NUMBER }}
    steps:
      # ... seus steps de deploy aqui
```

## Branches Suportadas

- `develop`
- `homolog`
- `master`
- `test`

Se a action for executada em uma branch não listada, ela falhará com uma mensagem de erro indicando as branches suportadas.

## Migração

### Antes (usando variável de repositório)

```yaml
env:
  AWS_ACCOUNT_NUMBER: ${{ vars.AWS_ACCOUNT_NUMBER }}
```

### Depois (usando a action)

```yaml
jobs:
  get-aws-account:
    runs-on: ubuntu-latest
    outputs:
      account-number: ${{ steps.get-account.outputs.account-number }}
    steps:
      - uses: orbitspot/actions/.github/actions/get-aws-account-number@v21
        id: get-account

  my-job:
    needs: [get-aws-account]
    env:
      AWS_ACCOUNT_NUMBER: ${{ needs.get-aws-account.outputs.account-number }}
```

Ou via setup-config:

```yaml
  setup-config:
    needs: [get-aws-account]
    outputs:
      AWS_ACCOUNT_NUMBER: ${{ needs.get-aws-account.outputs.account-number }}

  my-job:
    needs: [setup-config]
    env:
      AWS_ACCOUNT_NUMBER: ${{ needs.setup-config.outputs.AWS_ACCOUNT_NUMBER }}
```
