targetScope = 'subscription'

// Parameters
param parLocation string
param parEnvironment string
param parTags object

// Variables
var varAppSvcPlanResourceGroupName = 'rg-platform-plan-${parEnvironment}-${parLocation}'
var varApimResourceGroupName = 'rg-apim-${parEnvironment}-${parLocation}'
var varApimName = 'apim-mx-platform-${parEnvironment}-${parLocation}'
var varAppServicePlanName = 'plan-platform-${parEnvironment}-${parLocation}'

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
