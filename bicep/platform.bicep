targetScope = 'subscription'

// Parameters
param parEnvironment string
param parLocation string
param parInstance string

param parTags object

param parSqlAdminOid string
param parKeyVaultCreateMode string = 'recover'

// Variables
var varEnvironmentUniqueId = uniqueString('strategic', parEnvironment, parInstance)
var varDeploymentPrefix = 'services-${varEnvironmentUniqueId}' //Prevent deployment naming conflicts

var varKeyVaultResourceGroupName = 'rg-platform-vault-${parEnvironment}-${parLocation}-${parInstance}'
var varApimResourceGroupName = 'rg-platform-apim-${parEnvironment}-${parLocation}-${parInstance}'
var varSqlResourceGroupName = 'rg-platform-sql-${parEnvironment}-${parLocation}-${parInstance}'
var varAcrResourceGroupName = 'rg-platform-acr-${parEnvironment}-${parLocation}-${parInstance}'

var varKeyVaultName = 'kv-${varEnvironmentUniqueId}-${parLocation}'
var varApimName = 'apim-platform-${parEnvironment}-${parLocation}-${varEnvironmentUniqueId}'
var varSqlServerName = 'sql-platform-${parEnvironment}-${parLocation}-${parInstance}-${varEnvironmentUniqueId}'
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

resource keyVaultRef 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVault.outputs.outKeyVaultName
  scope: resourceGroup(keyVaultResourceGroup.name)
}

resource apimResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: varApimResourceGroupName
  location: parLocation
  tags: parTags

  properties: {}
}

module apiManagment 'platform/apiManagement.bicep' = {
  name: '${varDeploymentPrefix}-apiManagement'
  scope: resourceGroup(apimResourceGroup.name)

  params: {
    parApimName: varApimName
    parLocation: parLocation
  }
}

resource sqlResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: varSqlResourceGroupName
  location: parLocation
  tags: parTags

  properties: {}
}

module sqlServer 'platform/sqlServer.bicep' = {
  name: '${varDeploymentPrefix}-sqlServer'
  scope: resourceGroup(sqlResourceGroup.name)

  params: {
    parEnvironment: parEnvironment
    parLocation: parLocation
    parInstance: parInstance

    parSqlServerName: varSqlServerName

    parSqlAdminUsername: keyVaultRef.getSecret('sql-platform-${parEnvironment}-admin-username')
    parSqlAdminPassword: keyVaultRef.getSecret('sql-platform-${parEnvironment}-admin-password')
    parAdminGroupOid: parSqlAdminOid
  }
}

resource acrResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' =
  if (parEnvironment == 'prd') {
    name: varAcrResourceGroupName
    location: parLocation
    tags: parTags

    properties: {}
  }

module containerRegistry 'modules/containerRegistry.bicep' =
  if (parEnvironment == 'prd') {
    name: '${varDeploymentPrefix}-containerRegistry'
    scope: resourceGroup(acrResourceGroup.name)

    params: {
      parAcrName: varAcrName
      parLocation: parLocation
      parAcrSku: 'Basic'
      parTags: parTags
    }
  }
