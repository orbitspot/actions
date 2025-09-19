# Copilot Instructions for OrbitSpot Actions Repository

This repository contains reusable GitHub Actions and infrastructure modules for deploying microservices to AWS via Kubernetes with Istio service mesh.

## Architecture Overview

### Multi-Environment Infrastructure
- **Branches map to environments**: `master` (prod), `homolog` (staging), `develop` (dev)
- **Branch-specific configurations** in `terraform/api-gateway/variable.tf` and `helm-values/` templates
- **Environment templating** using `${.<REPOSITORY-NAME>.<DEPLOYMENT-NAME>.config}` syntax in Helm values

### AWS API Gateway Integration Pattern
- **Dual routing modes**: OAuth2 (`/oauth`) and default (`/api`) routes per environment
- **Version-based proxy scripts**: `v1` (complex request transformation) vs `v2` (simple HTTP_PROXY)
- **Custom authorizer integration**: All requests pass through context.authorizer with user/tenant metadata
- **Repository-based resource naming**: `replace(var.repository_name, "-", "")` for API Gateway resources

### Kubernetes Deployment Patterns
- **Istio-enabled by default**: Service mesh with egress gateway configuration
- **KEDA autoscaling**: CPU-based scaling (90% threshold) with configurable min/max replicas
- **CSI secrets integration**: `application-permission` service account for AWS Parameter Store
- **Node selector templating**: `${.<REPOSITORY-NAME>.<DEPLOYMENT-NAME>.node_selector}` for workload placement

## Critical Development Conventions

### GitHub Actions Best Practices
- **Environment variables**: UPPERCASE for environment-wide, lowercase for action inputs
- **Parameter quoting**: Always use single quotes for action parameters (GitHub expects strings)
- **Composite action pattern**: All actions use `composite` with multi-step shells
- **Artifact workflow**: Build → Upload artifacts → Download in deploy actions

### Terraform Module Structure
```
terraform/
├── api-gateway/           # AWS API Gateway proxy setup
│   ├── modules/default/   # Route handling with v1/v2 scripts
│   └── locals.tf         # Branch-based environment resolution
└── parameter-store/      # AWS SSM Parameter management
    ├── variables.json    # Environment variables (required file)
    └── secrets.json      # Secure strings (required file)
```

### Parameter Store Conventions
- **Environment variables**: `/${var.repository}/environment/${key}` (String type)
- **Secrets**: `/${var.repository}/secret/${key}` (SecureString type)  
- **Version tagging**: `orbit:modulo` tag with `var.modulo` for organization
- **JSON file requirements**: `variables.json` and `secrets.json` must exist in parameter-store module

### Helm Values Templating
- **Repository placeholder**: `<REPOSITORY-NAME>` replaced with actual repo name
- **Deployment placeholder**: `<DEPLOYMENT-NAME>` for multi-service repos
- **Grafana integration**: `<GRAFANA-TAG>` for monitoring/alerting setup
- **Resource requests**: Always define CPU/memory requests and limits

## Essential Commands & Workflows

### Terraform Operations
```bash
# API Gateway deployment requires branch and repository context
terraform plan -var="branch=develop" -var="repository_name=my-service"

# Parameter Store expects JSON files in working directory  
terraform apply # requires variables.json and secrets.json
```

### Helm Deployment Flow
1. `kubernetes-auth` action sets up kubectl + helm with AWS IAM
2. `prepare-helm-chart-values` processes templates with environment variables
3. `helm-deploy` applies chart with computed values and sets

### Docker Build Pattern
- **ECR auto-creation**: Repositories created if missing with lifecycle policies
- **Multi-stage artifacts**: Download build artifacts before Docker build
- **Tagging strategy**: `image:tag` format with ECR registry prefixing

## Integration Points

### AWS Service Dependencies
- **IAM roles**: `${{ env.AWS_ROLE_NAME }}` assumed in `${{ env.AWS_ACCOUNT_NUMBER }}`
- **S3 backends**: All Terraform uses S3 state storage with separate bucket per module
- **ECR registries**: Per-repository with automated lifecycle management
- **Parameter Store**: Centralized configuration storage with environment/secret separation

### Kubernetes Ecosystem
- **Istio service mesh**: Egress gateways for database connections, ingress for routing
- **KEDA scaling**: HPA replacement with external metric triggers  
- **AWS Load Balancer Controller**: For ingress management (annotation-driven)
- **CSI driver**: Direct Parameter Store integration without init containers

## Key Files & Patterns

- `terraform/api-gateway/locals.tf`: Environment resolution and URI construction logic
- `helm-values/*/values.yaml`: Service-specific deployment templates
- `.github/actions/*/action.yml`: Reusable CI/CD building blocks
- `terraform/parameter-store/mail.tf`: Configuration and secret management

When working with this codebase, always consider the branch-environment mapping and ensure consistency between Terraform variables, Helm templates, and action configurations.
