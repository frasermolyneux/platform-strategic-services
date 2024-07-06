targetScope = 'resourceGroup'

// Parameters
@description('The key vault resource name')
param keyVaultName string

param secretName string
@secure()
param secretValue string
param tags object

// Existing In-Scope Resources
resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName
}

// Module Resources
resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: secretName
  parent: keyVault
  tags: tags

  properties: {
    contentType: 'text/plain'
    value: secretValue
  }
}
