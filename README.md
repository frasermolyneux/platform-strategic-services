# Platform Strategic Services

[![Build and Test](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/build-and-test.yml)
[![Code Quality](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/codequality.yml/badge.svg)](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/codequality.yml)
[![Deploy Dev](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/deploy-dev.yml/badge.svg)](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/deploy-dev.yml)
[![Deploy Prd](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/deploy-prd.yml/badge.svg)](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/deploy-prd.yml)
[![PR Verify](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/pr-verify.yml/badge.svg)](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/pr-verify.yml)
[![Dependabot Auto-Merge](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/dependabot-automerge.yml/badge.svg)](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/dependabot-automerge.yml)
[![Copilot Setup Steps](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/copilot-setup-steps.yml/badge.svg)](https://github.com/frasermolyneux/platform-strategic-services/actions/workflows/copilot-setup-steps.yml)

## Documentation

- [Architecture Overview](docs/architecture-overview.md) - Subscription-scoped Bicep layout, resources, and naming conventions
- [Development Workflows](docs/development-workflows.md) - How pipelines validate and deploy each environment plus local CLI commands

## Overview

This repository contains subscription-scoped Bicep templates that provision shared platform services for downstream workloads. It deploys a Key Vault in every environment for centralised secrets management and an Azure Container Registry in production for shared container images. Resource groups and resource names are derived deterministically from environment, location, and instance parameters to ensure idempotency and avoid collisions. GitHub Actions workflows handle linting, validation, what-if previews, and deployments to dev and production environments on push, pull request, and weekly schedules.

## Contributing

Please read the [contributing](CONTRIBUTING.md) guidance; this is a learning and development project.

## Security

Please read the [security](SECURITY.md) guidance; I am always open to security feedback through email or opening an issue.
