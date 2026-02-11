# Development Workflows

## Pipelines
- **release-to-production**: Lints Bicep, validates dev/prd with `what-if`, then deploys both environments. Triggered on `main` and weekly (Thu 03:00 UTC).
- **devops-secure-scanning**: Runs security scanning template weekly (Thu 02:00 UTC) and on `main` PRs.
- Pipeline templates come from the `frasermolyneux/ado-pipeline-templates` repo via service connection `github.com_frasermolyneux`.

## Service connections and environments
- Dev deployments use Azure service connection `spn-platform-strategic-services-development` targeting environment `platform-strategic-services-Development`.
- Prod deployments use `spn-platform-strategic-services-production` targeting environment `platform-strategic-services-Production`.

## Local validation and deployment
Prereqs: Azure CLI logged into the correct tenant with subscription access; Bicep CLI available (bundled with recent Azure CLI).

- Validate existing environment (respects `keyVaultCreateMode='recover'` only when the vault already exists):
  ```powershell
  $envName = 'dev' # or 'prd'
  $config = Get-Content ./params/$envName.json | ConvertFrom-Json
  az deployment sub validate `
    --name "strategicServices$envName" `
    --template-file bicep/main.bicep `
    --location $config.parameters.location.value `
    --parameters @params/$envName.json `
      keyVaultCreateMode='recover'
  ```
- What-if preview:
  ```powershell
  az deployment sub what-if `
    --name "strategicServices$envName" `
    --template-file bicep/main.bicep `
    --location $config.parameters.location.value `
    --parameters @params/$envName.json `
      keyVaultCreateMode='recover'
  ```
- Deploy (auto-detects if Key Vault must be recovered):
  ```powershell
  $keyVaultCreateMode = 'default'
  $deleted = az keyvault list-deleted --query "[?contains(properties.vaultId, 'rg-platform-vault-'+$envName+'-'+$config.parameters.location.value+'-'+$config.parameters.instance.value)].properties.vaultId" -o tsv
  if ($deleted) { $keyVaultCreateMode = 'recover' }

  az deployment sub create `
    --name "strategicServices$envName" `
    --template-file bicep/main.bicep `
    --location $config.parameters.location.value `
    --parameters @params/$envName.json `
      keyVaultCreateMode=$keyVaultCreateMode
  ```

## Updating parameters
- Edit `params/dev.json` or `params/prd.json` for environment/location/instance or tags.
- Keep `tags` aligned across environments to maintain governance reporting.

## Adding resources
- Extend `bicep/modules` with new components and reference them from `bicep/main.bicep`.
- Preserve subscription scope and deterministic naming; update parameter files if new parameters are introduced.
