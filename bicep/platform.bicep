targetScope = 'subscription'

// Parameters
param parEnvironment string
param parLocation string
param parInstance string

param parTags object

param parKeyVaultCreateMode string = 'recover'

// Variables
var varEnvironmentUniqueId = uniqueString('strategic', parEnvironment, parInstance)
var varDeploymentPrefix = 'services-${varEnvironmentUniqueId}' //Prevent deployment naming conflicts

var varKeyVaultResourceGroupName = 'rg-platform-vault-${parEnvironment}-${parLocation}-${parInstance}'
var varAcrResourceGroupName = 'rg-platform-acr-${parEnvironment}-${parLocation}-${parInstance}'

var varKeyVaultName = 'kv-${varEnvironmentUniqueId}-${parLocation}'
var varAcrName = 'acr${varEnvironmentUniqueId}'

// Platform
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

    parKeyVaultCreateMode: parKeyVaultCreateMode
    parEnabledForDeployment: true
    parEnabledForTemplateDeployment: true
    parEnabledForRbacAuthorization: true

    parSoftDeleteRetentionInDays: 30

    parTags: parTags
  }
}

resource acrResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = if (parEnvironment == 'prd') {
  name: varAcrResourceGroupName
  location: parLocation
  tags: parTags

  properties: {}
}

module containerRegistry 'modules/containerRegistry.bicep' = if (parEnvironment == 'prd') {
  name: '${varDeploymentPrefix}-containerRegistry'
  scope: resourceGroup(acrResourceGroup.name)

  params: {
    parAcrName: varAcrName
    parLocation: parLocation
    parAcrSku: 'Basic'
    parTags: parTags
  }
}
