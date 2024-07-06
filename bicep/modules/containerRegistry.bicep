targetScope = 'resourceGroup'

// Parameters
@minLength(5)
@maxLength(50)
@description('Provide a globally unique name of your Azure Container Registry')
param acrName string = 'acr${uniqueString(resourceGroup().id)}'

@description('Provide a location for the registry.')
param location string = resourceGroup().location

@description('Provide a tier of your Azure Container Registry.')
param acrSku string = 'Basic'

@description('Tags to be applied to resource when deployed.  Default: None')
param tags object = {}

// Module Resources
resource resAzureContainerRegistry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: acrName
  tags: tags
  location: location

  sku: {
    name: acrSku
  }

  properties: {
    adminUserEnabled: false
  }
}
