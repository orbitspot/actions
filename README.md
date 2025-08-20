# Boas Práticas na criação de actions

### Escrita
- ENVs maiúsculas e with minúsculas
- Usar aspas simples para todos os parâmetros, pois o github sempre espera strings

### ENV vs with:
- ENV são para variáveis de ambiente e with são para parâmetros que não dependem do ambiente.
- ENV fica disponível para todos os steps/workflow, enquanto o with apenas para a action que aceita o seu input.
- ENVs de devops e outras que mais de um step precisar, setar à nível de job.

