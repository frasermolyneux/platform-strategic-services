targetScope = 'subscription'

// Parameters
param parLocation string
param parEnvironment string
param parTags object

// Variables
var varFrontDoorResourceGroupName = 'rg-frontdoor-${parEnvironment}-${parLocation}'
var varAppSvcPlanResourceGroupName = 'rg-plan-${parEnvironment}-${parLocation}'

// Platform
resource frontDoorResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: varFrontDoorResourceGroupName
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
