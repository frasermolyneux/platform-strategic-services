targetScope = 'resourceGroup'

// Parameters
param parRoleDefinitionId string
param parPrincipalId string
param parKeyVaultName string

// Existing Resources
resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: parKeyVaultName
}

// Module Resources
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, parPrincipalId, parRoleDefinitionId)
  scope: keyVault

  properties: {
    roleDefinitionId: parRoleDefinitionId
    principalId: parPrincipalId
    principalType: 'ServicePrincipal'
  }
}
