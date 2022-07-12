targetScope = 'resourceGroup'

// Parameters
param parApimName string
param parLocation string

// Module Resources
resource apiManagement 'Microsoft.ApiManagement/service@2021-12-01-preview' = {
  name: parApimName
  location: parLocation

  sku: {
    capacity: 0
    name: 'Consumption'
  }

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    publisherEmail: 'admin@mx-mail.io'
    publisherName: 'admin@mx-mail.io'
  }
}

resource tenantIdNamedValue 'Microsoft.ApiManagement/service/namedValues@2021-08-01' = {
  name: 'tenant-id'
  parent: apiManagement

  properties: {
    displayName: 'tenant-id'
    value: tenant().tenantId
    secret: false
  }
}

resource tenantLoginUrlNamedValue 'Microsoft.ApiManagement/service/namedValues@2021-08-01' = {
  name: 'tenant-login-url'
  parent: apiManagement

  properties: {
    displayName: 'tenant-login-url'
    value: environment().authentication.loginEndpoint
    secret: false
  }
}

// Outputs
output outApimId string = apiManagement.id
output outApimName string = apiManagement.name
