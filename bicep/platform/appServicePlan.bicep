targetScope = 'resourceGroup'

// Parameters
param parAppServicePlanName string
param parLocation string

// Module Resources
resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: parAppServicePlanName
  location: parLocation

  sku: {
    name: 'P1v3'
    tier: 'Premium'
    size: 'P1'
    family: 'P'
    capacity: 1
  }

  kind: 'linux'

  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

// Outputs
output outAppServicePlanId string = appServicePlan.id
output outAppServicePlanName string = appServicePlan.name
