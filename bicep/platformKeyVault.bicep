targetScope = 'subscription'

// Parameters
param parLocation string
param parEnvironment string
param parDeployPrincipalId string

param parPlatformKeyVaultCreateMode string = 'recover'

param parTags object

// Variables
var varDeploymentPrefix = 'strategicKeyVault' //Prevent deployment naming conflicts
var varKeyVaultName = 'kv-${uniqueString(subscription().id)}-${parLocation}'
var varKeyVaultResourceGroupName = 'rg-platform-vault-${uniqueString(subscription().id)}-${parEnvironment}-${parLocation}'

// Module Resources
resource keyVaultResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: varKeyVaultResourceGroupName
  location: parLocation
  tags: parTags

  properties: {}
}

module keyVault 'modules/keyVault.bicep' = {
  name: '${varDeploymentPrefix}-keyVault'
  scope: resourceGroup(keyVaultResourceGroup.name)

  params: {
    parKeyVaultName: varKeyVaultName
    parLocation: parLocation

    parKeyVaultCreateMode: parPlatformKeyVaultCreateMode
    parEnabledForDeployment: true
    parEnabledForTemplateDeployment: true
    parEnabledForRbacAuthorization: true

    parSoftDeleteRetentionInDays: 90

    parTags: parTags
  }
}

@description('https://learn.microsoft.com/en-gb/azure/role-based-access-control/built-in-roles#key-vault-secrets-officer')
resource keyVaultSecretsOfficerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  name: 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
}

module keyVaultSecretUserRoleAssignment 'modules/keyVaultRoleAssignment.bicep' = {
  name: '${varDeploymentPrefix}-keyVaultSecretUserRoleAssignment'
  scope: resourceGroup(keyVaultResourceGroup.name)

  params: {
    parKeyVaultName: keyVault.outputs.outKeyVaultName
    parRoleDefinitionId: keyVaultSecretsOfficerRoleDefinition.id
    parPrincipalId: parDeployPrincipalId
  }
}

// Outputs
output keyVaultName string = keyVault.outputs.outKeyVaultName
