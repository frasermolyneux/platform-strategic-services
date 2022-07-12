targetScope = 'subscription'

// Parameters
param parLocation string
param parEnvironment string
param parTags object

@secure()
param parSqlAdminUsername string
@secure()
param parSqlAdminPassword string
param parSqlAdminOid string

// Variables
var varKeyVaultResourceGroupName = 'rg-platform-keyvault-${parEnvironment}-${parLocation}'
var varAppSvcPlanResourceGroupName = 'rg-platform-webapps-${parEnvironment}-${parLocation}'
var varApimResourceGroupName = 'rg-platform-apim-${parEnvironment}-${parLocation}'
var varSqlResourceGroupName = 'rg-platform-sql-${parEnvironment}-${parLocation}'

var varKeyVaultName = 'kv-mx-platform-${parEnvironment}-${parLocation}'
var varApimName = 'apim-mx-platform-${parEnvironment}-${parLocation}'
var varAppServicePlanName = 'plan-platform-${parEnvironment}-${parLocation}'

// Platform
resource keyVaultResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: varKeyVaultResourceGroupName
  location: parLocation
  tags: parTags

  properties: {}
}

resource appSvcPlanResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: varAppSvcPlanResourceGroupName
  location: parLocation
  tags: parTags

  properties: {}
}

resource apimResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: varApimResourceGroupName
  location: parLocation
  tags: parTags

  properties: {}
}

resource sqlResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: varSqlResourceGroupName
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

module apiManagment 'platform/apiManagement.bicep' = {
  name: 'apiManagement'
  scope: resourceGroup(apimResourceGroup.name)

  params: {
    parApimName: varApimName
    parLocation: parLocation
  }
}

module appServicePlan 'platform/appServicePlan.bicep' = {
  name: 'appServicePlan'
  scope: resourceGroup(appSvcPlanResourceGroup.name)

  params: {
    parAppServicePlanName: varAppServicePlanName
    parLocation: parLocation
  }
}

module sqlServer 'platform/sqlServer.bicep' = {
  name: 'sqlServer'
  scope: resourceGroup(sqlResourceGroup.name)

  params: {
    parLocation: parLocation
    parEnvironment: parEnvironment
    parSqlAdminUsername: parSqlAdminUsername
    parSqlAdminPassword: parSqlAdminPassword
    parAdminGroupOid: parSqlAdminOid
  }
}
