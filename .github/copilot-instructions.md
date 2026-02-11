# Copilot Instructions

- **Purpose**: Subscription-scoped Bicep that provisions shared platform services (Key Vault every env, ACR in prod) for downstream workloads.
- **Entry points**: `bicep/main.bicep` drives deployments; modules under `bicep/modules/` implement Key Vault, ACR, optional KV role assignment and secret helpers.
- **Parameters**: `params/dev.json` and `params/prd.json` supply `environment`, `location`, `instance`, and `tags`. Keep names/tag shapes aligned across environments.
- **Naming**: Uses `uniqueString('strategic', environment, instance)` to derive `kv-{uniqueId}-{location}` and `acr{uniqueId}`; avoid changing this to preserve idempotency.
- **Key Vault create mode**: Default is `recover` for validation/what-if when a vault exists; deploy stage sets `recover` only if a deleted vault is detected to allow fresh creates with `default`.
- **Resource groups**: Vault in `rg-platform-vault-{env}-{location}-{instance}`; ACR (prod) in `rg-platform-acr-{env}-{location}-{instance}`.
- **Pipelines**: `.azure-pipelines/release-to-production.yml` runs lint → validate/what-if (dev, prd) → deploy (dev, prd). `.azure-pipelines/devops-secure-scanning.yml` runs security scanning. Templates come from `frasermolyneux/ado-pipeline-templates` via service connection `github.com_frasermolyneux`.
- **Service connections/environments**: Dev uses `spn-platform-strategic-services-development` and environment `platform-strategic-services-Development`; prod uses `spn-platform-strategic-services-production` and `platform-strategic-services-Production`.
- **Local commands**: Use Azure CLI with `az deployment sub validate|what-if|create --template-file bicep/main.bicep --parameters @params/{env}.json keyVaultCreateMode=<mode>`; check for deleted vaults before deciding `recover` vs `default`.
- **Security defaults**: Key Vault enforces purge protection, RBAC auth, empty access policies, and open network ACLs (AzureServices bypass, allow by default). ACR disables admin user.
- **Extending**: Add new modules under `bicep/modules` and reference from `main.bicep`; update parameter files for new inputs. Preserve subscription scope and naming conventions.
- **Docs**: See `docs/architecture-overview.md` for resource layout and `docs/development-workflows.md` for pipeline/local deployment details.
