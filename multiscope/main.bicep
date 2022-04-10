targetScope = 'subscription'
@description('the location storing the policy meta data')
param location string = deployment().location
param virtualNetworkName string
param virtualNetworkAddressPrefix string

var policyDefinitionName = 'DenyFandGSeriesVMs'
var policyAssignmentName = 'DenyFandGSeriesVMs'
var resourceGroupName = 'ToyNetworking'

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: policyDefinitionName
  properties: {
    displayName: policyDefinitionName
    policyType: 'Custom'
    mode: 'All'
    description: 'do not allow creating F and G Series VMs'
    parameters: {}
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Compute/virtualMachines'
          }
          {
            anyOf: [
              {
                field: 'Microsoft.Compute/virtualMachines/sku.name'
                like: 'Standard_F*'
              }
              {
                field: 'Microsoft.Compute/virtualMachines/sku.name'
                like: 'Standard_G*'
              }
            ]
          }
        ]
      }
      then: {
        effect: 'Deny'
      }
    }
  }
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: policyAssignmentName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    policyDefinitionId: policyDefinition.id
  }
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module virtualNetwork 'modules/virtualNetwork.bicep' = {
  scope: resourceGroup
  name: 'virtualNetwork'
  params: {
    virtualNetworkAddressPrefix: virtualNetworkAddressPrefix
    virtualNetworkName: virtualNetworkName
  }
}
