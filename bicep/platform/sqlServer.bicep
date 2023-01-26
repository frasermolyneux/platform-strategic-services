targetScope = 'resourceGroup'

// Parameters
param parEnvironment string
param parLocation string
param parInstance string

param parSqlServerName string

@secure()
param parSqlAdminUsername string
@secure()
param parSqlAdminPassword string
param parAdminGroupOid string

// Variables
var varSqlAdminGroupName = 'sg-sql-platform-admins-${parEnvironment}-${parInstance}'

// Module Resources
resource sqlServer 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: parSqlServerName
  location: parLocation

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    version: '12.0'

    publicNetworkAccess: 'Enabled'

    administratorLogin: parSqlAdminUsername
    administratorLoginPassword: parSqlAdminPassword

    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: false
      login: varSqlAdminGroupName
      principalType: 'Group'
      sid: parAdminGroupOid
      tenantId: tenant().tenantId
    }
  }
}

resource allowAzureServicesFirewallRule 'Microsoft.Sql/servers/firewallRules@2021-11-01-preview' = {
  parent: sqlServer
  name: 'allowAzureServicesFirewallRule'

  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

// Outputs
output outSqlServerName string = sqlServer.name
