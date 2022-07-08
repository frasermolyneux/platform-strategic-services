targetScope = 'resourceGroup'

param parAppServicePlanName string
param parLocation string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: parAppServicePlanName
  location: parLocation

  kind: 'linux'

  sku: {
    name: 'S1'
    tier: 'Standard'
  }
}

output outAppServicePlanId string = appServicePlan.id
output outAppServicePlanName string = appServicePlan.name
