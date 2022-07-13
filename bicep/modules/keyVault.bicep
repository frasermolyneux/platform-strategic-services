targetScope = 'resourceGroup'

// Parameters
param parKeyVaultName string
param parLocation string
param parTags object

// Module Resources
resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: parKeyVaultName
  location: parLocation
  tags: parTags

  properties: {
    accessPolicies: []
    createMode: 'default'

    enablePurgeProtection: true
    enableRbacAuthorization: false
    enabledForDeployment: true
    enabledForTemplateDeployment: true

    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }

    sku: {
      family: 'A'
      name: 'standard'
    }

    tenantId: tenant().tenantId
  }
}

// Outputs
output outKeyVaultName string = keyVault.name
