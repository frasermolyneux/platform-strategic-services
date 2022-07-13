targetScope = 'subscription'

// Parameters
param parLocation string
param parEnvironment string
param parTags object

// Variables
var varKeyVaultName = 'kv-mx-pltfrm-${parEnvironment}-${parLocation}'
var varKeyVaultResourceGroupName = 'rg-platform-keyvault-${parEnvironment}-${parLocation}'

// Module Resources
resource keyVaultResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: varKeyVaultResourceGroupName
  location: parLocation
  tags: parTags

  properties: {}
}

module keyVault 'modules/keyVault.bicep' = {
  name: 'keyVault'
  scope: resourceGroup(keyVaultResourceGroup.name)

  params: {
    parKeyVaultName: varKeyVaultName
    parLocation: parLocation
    parTags: parTags
  }
}
