# Architecture Overview

## Scope and goal
- Subscription-scoped Bicep deployment that provisions shared platform services for multiple workloads.
- Always deploys a Key Vault per environment; production also adds an Azure Container Registry for shared images.

## Resource model
- **Key Vault**: Created in resource group `rg-platform-vault-{env}-{location}-{instance}` with purge protection, RBAC enabled, and template/deployment access. Naming uses `kv-{uniqueId}-{location}` where `uniqueId = uniqueString('strategic', environment, instance)`.
- **Azure Container Registry (prod only)**: Created in `rg-platform-acr-{env}-{location}-{instance}` with a deterministic name `acr{uniqueId}` and SKU `Basic`, admin user disabled.
- **Tags**: Passed from `params/*.json`; default include `Environment`, `Workload`, `DeployedBy`, and repo link.
- **Optional modules**: Helpers exist for Key Vault role assignments and secrets (`modules/keyVaultRoleAssignment.bicep`, `modules/keyVaultSecret.bicep`) though not invoked from `main.bicep` today.

## Configuration inputs
- Parameters come from `params/dev.json` and `params/prd.json` specifying `environment`, `location` (e.g., `uksouth`), `instance` (e.g., `01`), and common `tags`.
- `keyVaultCreateMode` defaults to `recover` in the pipeline preflight to preserve access policies if the vault already exists. Deploy stage sets it to `recover` only when a deleted vault is detected so fresh environments use `default`.

## Deployment flow
- `.azure-pipelines/release-to-production.yml` stages:
  - Lint Bicep with templates from `frasermolyneux/ado-pipeline-templates`.
  - Per-environment validation (`what-if`/`validate`) gates using service connections `spn-platform-strategic-services-development` and `spn-platform-strategic-services-production`.
  - Deploy stages run `az deployment sub create` with the appropriate parameter file and computed `keyVaultCreateMode`.
- `.azure-pipelines/devops-secure-scanning.yml` runs weekly and on main for security scanning via template repo.

## Naming conventions
- Resource groups: `rg-platform-vault-{env}-{location}-{instance}` and `rg-platform-acr-{env}-{location}-{instance}`.
- Key Vault: `kv-{uniqueId}-{location}`; Container Registry: `acr{uniqueId}`; `uniqueId` is stable per environment/instance to avoid collisions across redeploys.

## Cross-repo relationships
- Pipelines rely on templates from `frasermolyneux/ado-pipeline-templates` fetched via the GitHub service connection `github.com_frasermolyneux`.
