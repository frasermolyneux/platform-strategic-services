targetScope = 'subscription'

// Parameters
param parLocation string
param parEnvironment string
param parTags object

// Variables
var varAppSvcPlanResourceGroupName = 'rg-plan-${parEnvironment}-${parLocation}'

// Platform
resource appSvcPlanResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: varAppSvcPlanResourceGroupName
  location: parLocation
  tags: parTags

  properties: {}
}
