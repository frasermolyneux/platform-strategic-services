# Copilot Instructions

## Project overview

This repository contains subscription-scoped Bicep templates that provision shared platform services for downstream workloads. Every environment gets a Key Vault for centralised secrets; production also deploys an Azure Container Registry for shared container images.

## Repository layout

- `bicep/main.bicep` — entry point for all deployments (subscription scope).
- `bicep/modules/` — reusable modules: Key Vault, Container Registry, KV role assignment, KV secret helpers.
- `params/dev.json`, `params/prd.json` — environment parameter files supplying `environment`, `location`, `instance`, and `tags`.
- `.github/workflows/` — GitHub Actions CI/CD pipelines (see below).
- `.azure-pipelines/` — legacy Azure DevOps pipelines (retained for reference).
- `docs/` — architecture overview and development workflow documentation.

## Naming conventions

- Resource names use `uniqueString('strategic', environment, instance)` to produce a stable unique ID.
- Key Vault: `kv-{uniqueId}-{location}` in resource group `rg-platform-vault-{env}-{location}-{instance}`.
- Container Registry (prod only): `acr{uniqueId}` in resource group `rg-platform-acr-{env}-{location}-{instance}`.
- Do not change the `uniqueString` seed — it preserves idempotency across redeploys.

## CI/CD workflows (GitHub Actions)

- `build-and-test.yml` — Bicep lint and build on feature/bugfix/hotfix branches.
- `pr-verify.yml` — Bicep lint, build, and what-if for dev on all pull requests.
- `deploy-dev.yml` — manual dispatch to deploy dev environment.
- `deploy-prd.yml` — deploys dev then prod on push to `main`, weekly schedule, or manual dispatch.
- `codequality.yml` — security scanning (reusable workflow) and dependency review on PRs.
- `dependabot-automerge.yml` — auto-merges Dependabot PRs.
- `copilot-setup-steps.yml` — setup steps for GitHub Copilot coding agent.

## Key Vault create mode

Default `keyVaultCreateMode` is `recover` to handle validation/what-if when a vault already exists. Deploy stages should set `recover` only when a soft-deleted vault is detected; otherwise use `default` for fresh creates.

## Security defaults

- Key Vault: purge protection enabled, RBAC authorisation, empty access policies, network ACLs allow Azure services.
- Container Registry: admin user disabled.

## Extending the project

- Add new Bicep modules under `bicep/modules/` and reference them from `main.bicep`.
- Update `params/dev.json` and `params/prd.json` for any new parameters; keep tag shapes aligned.
- Preserve subscription scope and deterministic naming conventions.

## Local development

Use Azure CLI to validate, preview, or deploy:
```
az deployment sub what-if --location uksouth --template-file bicep/main.bicep --parameters @params/dev.json
az deployment sub create --location uksouth --template-file bicep/main.bicep --parameters @params/dev.json
```

## Documentation

Refer to `docs/architecture-overview.md` for resource layout and `docs/development-workflows.md` for pipeline and local deployment details.
