targetScope = 'subscription'

// Parameters
@description('The environment for the resources')
param environment string

@description('The location to deploy the resources')
param location string
param instance string

param tags object

param keyVaultCreateMode string = 'recover'

// Variables
var environmentUniqueId = uniqueString('strategic', environment, instance)
var varDeploymentPrefix = 'services-${environmentUniqueId}' //Prevent deployment naming conflicts

var varKeyVaultResourceGroupName = 'rg-platform-vault-${environment}-${location}-${instance}'
var varAcrResourceGroupName = 'rg-platform-acr-${environment}-${location}-${instance}'

var keyVaultName = 'kv-${environmentUniqueId}-${location}'
var varAcrName = 'acr${environmentUniqueId}'

// Platform
resource keyVaultResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: varKeyVaultResourceGroupName
  location: location
  tags: tags

  properties: {}
}

module keyVault 'modules/keyVault.bicep' = {
  name: '${varDeploymentPrefix}-keyVault'
  scope: resourceGroup(keyVaultResourceGroup.name)

  params: {
    keyVaultName: keyVaultName
    location: location

    keyVaultCreateMode: keyVaultCreateMode
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForRbacAuthorization: true

    softDeleteRetentionInDays: 30

    tags: tags
  }
}

resource acrResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = if (environment == 'prd') {
  name: varAcrResourceGroupName
  location: location
  tags: tags

  properties: {}
}

module containerRegistry 'modules/containerRegistry.bicep' = if (environment == 'prd') {
  name: '${varDeploymentPrefix}-containerRegistry'
  scope: resourceGroup(acrResourceGroup.name)

  params: {
    acrName: varAcrName
    location: location
    acrSku: 'Basic'
    tags: tags
  }
}
