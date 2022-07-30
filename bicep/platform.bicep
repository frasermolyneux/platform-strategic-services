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
var varDeploymentPrefix = 'strategicPlatform' //Prevent deployment naming conflicts
var varAppSvcPlanResourceGroupName = 'rg-platform-webapps-${parEnvironment}-${parLocation}'
var varApimResourceGroupName = 'rg-platform-apim-${parEnvironment}-${parLocation}'
var varSqlResourceGroupName = 'rg-platform-sql-${parEnvironment}-${parLocation}'
var varAcrResourceGroupName = 'rg-platform-acr-${parEnvironment}-${parLocation}'

var varApimName = 'apim-mx-platform-${parEnvironment}-${parLocation}'
var varAppServicePlanName = 'plan-platform-${parEnvironment}-${parLocation}'
var varAcrName = 'acrmxplatform${parEnvironment}${parLocation}'

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

resource acrResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
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
  }
}

module sqlServer 'platform/sqlServer.bicep' = {
  name: '${varDeploymentPrefix}-sqlServer'
  scope: resourceGroup(sqlResourceGroup.name)

  params: {
    parLocation: parLocation
    parEnvironment: parEnvironment
    parSqlAdminUsername: parSqlAdminUsername
    parSqlAdminPassword: parSqlAdminPassword
    parAdminGroupOid: parSqlAdminOid
  }
}

module containerRegistry 'modules/containerRegistry.bicep' = {
  name: '${varDeploymentPrefix}-appServicePlan'
  scope: resourceGroup(acrResourceGroup.name)

  params: {
    parAcrName: varAcrName
    parLocation: parLocation
    parAcrSku: 'Basic'
    parTags: parTags
  }
}
