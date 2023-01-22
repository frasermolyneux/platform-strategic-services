targetScope = 'subscription'

// Parameters
param parLocation string
param parEnvironment string

@secure()
param parSqlAdminUsername string
@secure()
param parSqlAdminPassword string
param parSqlAdminOid string

param parAppServicePlanSkuName string
param parAppServicePlanSkuTier string
param parAppServicePlanSkuSize string
param parAppServicePlanSkuFamily string

param parTags object

// Variables
var varDeploymentPrefix = 'strategicPlatform' //Prevent deployment naming conflicts
var varAppSvcPlanResourceGroupName = 'rg-platform-webapps-${uniqueString(subscription().id)}-${parEnvironment}-${parLocation}'
var varApimResourceGroupName = 'rg-platform-apim-${uniqueString(subscription().id)}-${parEnvironment}-${parLocation}'
var varSqlResourceGroupName = 'rg-platform-sql-${uniqueString(subscription().id)}-${parEnvironment}-${parLocation}'
var varSqlServerName = 'sql-platform-${uniqueString(subscription().id)}-${parEnvironment}-${parLocation}'
var varAcrResourceGroupName = 'rg-platform-acr-${uniqueString(subscription().id)}-${parEnvironment}-${parLocation}'

var varApimName = 'apim-mx-platform-${uniqueString(subscription().id)}-${parEnvironment}-${parLocation}'
var varAppServicePlanName = 'plan-platform-${uniqueString(subscription().id)}-${parEnvironment}-${parLocation}-01'
var varAcrName = 'acr-${uniqueString(subscription().id)}${parEnvironment}${parLocation}'

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
    parSqlAdminUsername: parSqlAdminUsername
    parSqlAdminPassword: parSqlAdminPassword
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
