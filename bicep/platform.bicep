targetScope = 'subscription'

// Parameters
param parEnvironment string
param parLocation string
param parInstance string

param parSqlAdminOid string

param parAppServicePlanSkuName string
param parAppServicePlanSkuTier string
param parAppServicePlanSkuSize string
param parAppServicePlanSkuFamily string

param parTags object

// Variables
var varEnvironmentUniqueId = uniqueString('strategic', parEnvironment, parInstance)
var varDeploymentPrefix = 'services-${varEnvironmentUniqueId}' //Prevent deployment naming conflicts

var varAppSvcPlanResourceGroupName = 'rg-platform-plans-${parEnvironment}-${parLocation}-${parInstance}'
var varApimResourceGroupName = 'rg-platform-apim-${parEnvironment}-${parLocation}-${parInstance}'
var varSqlResourceGroupName = 'rg-platform-sql-${parEnvironment}-${parLocation}-${parInstance}'
var varAcrResourceGroupName = 'rg-platform-acr-${parEnvironment}-${parLocation}-${parInstance}'

var varAppServicePlanName = 'plan-platform-${parEnvironment}-${parLocation}-01' //TODO: Array of plans will be added later; hence the hardcoded 01
var varApimName = 'apim-platform-${parEnvironment}-${parLocation}-${varEnvironmentUniqueId}'
var varSqlServerName = 'sql-platform-${parEnvironment}-${parLocation}-${parInstance}-${varEnvironmentUniqueId}'
var varAcrName = 'acr${varEnvironmentUniqueId}'

// Existing Resources
resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'kv-${varEnvironmentUniqueId}-${parLocation}'
  scope: resourceGroup('rg-platform-vault-${parEnvironment}-${parLocation}-${parInstance}')
}

// Platform
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

resource acrResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = if (parEnvironment == 'prd') {
  name: varAcrResourceGroupName
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

module appServicePlan 'platform/appServicePlan.bicep' = {
  name: '${varDeploymentPrefix}-appServicePlan'
  scope: resourceGroup(appSvcPlanResourceGroup.name)

  params: {
    parAppServicePlanName: varAppServicePlanName
    parLocation: parLocation
    parSkuName: parAppServicePlanSkuName
    parSkuTier: parAppServicePlanSkuTier
    parSkuSize: parAppServicePlanSkuSize
    parSkuFamily: parAppServicePlanSkuFamily
  }
}

module sqlServer 'platform/sqlServer.bicep' = {
  name: '${varDeploymentPrefix}-sqlServer'
  scope: resourceGroup(sqlResourceGroup.name)

  params: {
    parSqlServerName: varSqlServerName
    parLocation: parLocation
    parEnvironment: parEnvironment
    parSqlAdminUsername: keyVault.getSecret('sql-platform-${parEnvironment}-admin-username')
    parSqlAdminPassword: keyVault.getSecret('sql-platform-${parEnvironment}-admin-password')
    parAdminGroupOid: parSqlAdminOid
  }
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
