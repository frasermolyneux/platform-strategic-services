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

    parSoftDeleteRetentionInDays: 30

    parTags: parTags
  }
}

module keyVaultAccessPolicy 'modules/keyVaultAccessPolicy.bicep' = {
  name: '${varDeploymentPrefix}-keyVaultAccessPolicy'
  scope: resourceGroup(keyVaultResourceGroup.name)

  params: {
    parKeyVaultName: keyVault.outputs.outKeyVaultName
    parPrincipalId: parDeployPrincipalId
    parSecretsPermissions: [ 'get', 'set', 'list' ]
  }
}

// Outputs
output keyVaultName string = keyVault.outputs.outKeyVaultName
