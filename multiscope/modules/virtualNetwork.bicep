param virtualNetworkName string
param virtualNetworkAddressPrefix string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: virtualNetworkName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
      virtualNetworkAddressPrefix
      ]
    }
  }
}
