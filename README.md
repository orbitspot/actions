# Boas Práticas na criação de actions

### ENV vs with:
- ENV são para variáveis de ambiente e with são para parâmetros que não dependem do ambiente.
- ENV fica disponível para todos os steps/workflow, enquanto o with apenas para a action que aceita o seu input.
- ENVs maiúsculas e with minúsculas

### 3 níveis de aninhamento
1. Workflow
2. Reutilização de jobs
3. Actions
