//********************************************
// Parameters
//********************************************

@description('Specifies the name of the user-defined managed identity used by the certificate manager.')
param name string = 'CertificateManagerManagedIdentity' 

@description('Specifies the location of the user-defined managed identity.')
param location string = resourceGroup().location

@description('Specifies the name of the AKS cluster.')
param aksClusterName string

@description('Specifies the name of an existing public DNS zone.')
param dnsZoneName string

@description('Specifies the name of the resource group which contains the public DNS zone.')
param dnsZoneResourceGroupName string

@description('Specifies the namespace of the application.')
param namespace string

@description('Specifies the service account of the application.')
param serviceAccountName string

@description('Specifies the resource tags.')
param tags object

//********************************************
// Resources
//********************************************

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-10-02-preview' existing = {
  name: aksClusterName
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: name
  location: location
  tags: tags
}

module dnsZoneContributorRoleAssignment './dnsZoneContributorRoleAssignment.bicep' = if (!empty(dnsZoneName) && !empty(dnsZoneResourceGroupName)) {
  name:  'dnsZoneContributorRoleAssignment'
  scope: resourceGroup(dnsZoneResourceGroupName)
  params: {
    principalId: managedIdentity.properties.principalId
    dnsZoneName: dnsZoneName
  }
}

// Create federated identity for the user-defined managed identity used by the workload
resource federatedIdentityCredentials 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = if (!empty(namespace) && !empty(serviceAccountName)) {
  name: 'FederatedIdentityCredentials'
  parent: managedIdentity
  properties: {
    issuer: aksCluster.properties.oidcIssuerProfile.issuerURL
    subject: 'system:serviceaccount:${namespace}:${serviceAccountName}'
    audiences: [
      'api://AzureADTokenExchange'
    ]
  }
}

//********************************************
// Outputs
//********************************************

output id string = managedIdentity.id
output name string = managedIdentity.name
output clientId string = managedIdentity.properties.clientId
output principalId string = managedIdentity.properties.principalId
