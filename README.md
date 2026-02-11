# Platform Strategic Services

[![DevOps Secure Scanning](https://dev.azure.com/frasermolyneux/Personal-Public/_apis/build/status%2Fplatform-strategic-services.DevOpsSecureScanning?branchName=main)](https://dev.azure.com/frasermolyneux/Personal-Public/_build/latest?definitionId=206&branchName=main)
[![Release Build](https://dev.azure.com/frasermolyneux/Personal-Public/_apis/build/status%2Fplatform-strategic-services.OnePipeline?repoName=frasermolyneux%2Fplatform-strategic-services&branchName=main&stageName=build)](https://dev.azure.com/frasermolyneux/Personal-Public/_build/latest?definitionId=171&repoName=frasermolyneux%2Fplatform-strategic-services&branchName=main)
[![Deploy Dev](https://dev.azure.com/frasermolyneux/Personal-Public/_apis/build/status%2Fplatform-strategic-services.OnePipeline?repoName=frasermolyneux%2Fplatform-strategic-services&branchName=main&stageName=deploy_dev)](https://dev.azure.com/frasermolyneux/Personal-Public/_build/latest?definitionId=171&repoName=frasermolyneux%2Fplatform-strategic-services&branchName=main)
[![Deploy Prd](https://dev.azure.com/frasermolyneux/Personal-Public/_apis/build/status%2Fplatform-strategic-services.OnePipeline?repoName=frasermolyneux%2Fplatform-strategic-services&branchName=main&stageName=deploy_prd)](https://dev.azure.com/frasermolyneux/Personal-Public/_build/latest?definitionId=171&repoName=frasermolyneux%2Fplatform-strategic-services&branchName=main)

## Documentation

- [Development Workflows](docs/development-workflows.md) - How pipelines validate and deploy each environment plus local CLI commands
- [Architecture Overview](docs/architecture-overview.md) - Subscription-scoped Bicep layout, resources, and naming conventions

## Overview

Subscription-scoped Bicep templates provision shared platform services: a Key Vault for secrets in every environment and an Azure Container Registry for production. Resource groups and names use deterministic environment, location, and instance inputs to avoid collisions. Azure DevOps pipelines lint, what-if, and deploy these templates to dev and prod on push and on weekly schedules.

## Contributing

Please read the [contributing](CONTRIBUTING.md) guidance; this is a learning and development project.

## Security

Please read the [security](SECURITY.md) guidance; I am always open to security feedback through email or opening an issue.
