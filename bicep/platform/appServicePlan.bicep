targetScope = 'resourceGroup'

// Parameters
param parAppServicePlanName string
param parLocation string

param parSkuName string = 'P1v3'
param parSkuTier string = 'Premium'
param parSkuSize string = 'P1'
param parSkuFamily string = 'P'
param parSkuCapacity int = 1

// Module Resources
resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: parAppServicePlanName
  location: parLocation

  sku: {
    name: parSkuName
    tier: parSkuTier
    size: parSkuSize
    family: parSkuFamily
    capacity: parSkuCapacity
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
