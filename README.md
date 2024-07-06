# Platform Strategic Services

| Stage                  | Status                                                                                                                                                                                                                                                                                                                                                                                     |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| DevOps Secure Scanning | [![Build Status](https://dev.azure.com/frasermolyneux/Personal-Public/_apis/build/status%2Fplatform-strategic-services.DevOpsSecureScanning?branchName=main)](https://dev.azure.com/frasermolyneux/Personal-Public/_build/latest?definitionId=206&branchName=main)                                                                                                                         |
| Build                  | [![Build Status](https://dev.azure.com/frasermolyneux/Personal-Public/_apis/build/status%2Fplatform-strategic-services.OnePipeline?repoName=frasermolyneux%2Fplatform-strategic-services&branchName=main&stageName=build)](https://dev.azure.com/frasermolyneux/Personal-Public/_build/latest?definitionId=171&repoName=frasermolyneux%2Fplatform-strategic-services&branchName=main)      |
| Deploy to Development  | [![Build Status](https://dev.azure.com/frasermolyneux/Personal-Public/_apis/build/status%2Fplatform-strategic-services.OnePipeline?repoName=frasermolyneux%2Fplatform-strategic-services&branchName=main&stageName=deploy_dev)](https://dev.azure.com/frasermolyneux/Personal-Public/_build/latest?definitionId=171&repoName=frasermolyneux%2Fplatform-strategic-services&branchName=main) |
| Deploy to Production   | [![Build Status](https://dev.azure.com/frasermolyneux/Personal-Public/_apis/build/status%2Fplatform-strategic-services.OnePipeline?repoName=frasermolyneux%2Fplatform-strategic-services&branchName=main&stageName=deploy_prd)](https://dev.azure.com/frasermolyneux/Personal-Public/_build/latest?definitionId=171&repoName=frasermolyneux%2Fplatform-strategic-services&branchName=main) |

---

## Overview

This repository contains the configuration and associated Azure DevOps pipelines for the MX tenant strategic services. These are services that are considered platform as they are shared by many workloads.

---

## Related Projects

* [frasermolyneux/azure-landing-zones](https://github.com/frasermolyneux/azure-landing-zones) - The deploy service principal is managed by this project, as is the workload subscription.

---

## Solution

The solution will deploy the following resources:

* Container Registry

---

## Azure Pipelines

The `one-pipeline` is within the `.azure-pipelines` folder and output is visible on the [frasermolyneux/Personal-Public](https://dev.azure.com/frasermolyneux/Personal-Public/_build?definitionId=171) Azure DevOps project.

---

## Contributing

Please read the [contributing](CONTRIBUTING.md) guidance; this is a learning and development project.

---

## Security

Please read the [security](SECURITY.md) guidance; I am always open to security feedback through email or opening an issue.
