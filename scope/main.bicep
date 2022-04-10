targetScope = 'subscription'
@description('the location storing the policy meta data')
param location string = 'westus'
var policyDefinitionName = 'DenyFandGSeriesVMs'
var policyAssignmentName = 'DenyFandGSeriesVMs'

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: policyDefinitionName
  properties: {
    displayName: policyDefinitionName
    policyType: 'Custom'
    mode: 'All'
    description: 'do not allow creating F and G Series VMs'
    // metadata: {
    //   version: '0.1.0'
    //   category: 'policy'
    //   source: 'source'
    // }
    parameters: {
      // parameterName: {
      //   type: 'String'
      //   defaultValue: 'defaultValue'
      //   metadata: {
      //     displayName: 'displayName'
      //     description: 'description'
      //   }
      // }
    }
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
    
    // displayName: 'displayName'
    // description: 'description'
    // enforcementMode: 'Default'
    // metadata: {
    //   source: 'source'
    //   version: '0.1.0'
    // }
    policyDefinitionId: policyDefinition.id
    // parameters: {
    //   parameterName: {
    //     value: 'value'
    //   }
    // }
    // nonComplianceMessages: [
    //   {
    //     message: 'message'
    //   }
    //   {
    //     message: 'message'
    //     policyDefinitionReferenceId: 'policyDefinitionReferenceId'
    //   }
    // ]
  }
}
