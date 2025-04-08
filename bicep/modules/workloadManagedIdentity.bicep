//********************************************
// Parameters
//********************************************

@description('Specifies the name of the user-defined managed identity.')
param name string

@description('Specifies the location of the user-defined managed identity.')
param location string = resourceGroup().location

@description('Specifies the name of the AKS cluster.')
param aksClusterName string

@description('Specifies the name of the Azure OpenAI resource.')
param openAiName string

@description('Specifies the namespace of the application.')
param namespace string

@description('Specifies the service account of the application.')
param serviceAccountName string

@description('Specifies the resource tags.')
param tags object

//********************************************
// Resources
//********************************************

resource cognitiveServicesUserRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  name: 'a97b65f3-24c7-4388-baec-2e87135dc908'
  scope: subscription()
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-10-02-preview' existing = {
  name: aksClusterName
}

resource openAi 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = if (!empty(openAiName)) {
  name: openAiName
}

//  This user-defined managed identity used by the workload to connect to the Azure OpenAI resource with a security token issued by Azue Active Directory
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: name
  location: location
  tags: tags
}


// Assign the Cognitive Services User role to the user-defined managed identity used by workloads
resource cognitiveServicesUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(openAiName)) {
  name:  guid(openAi.id, managedIdentity.id, cognitiveServicesUserRoleDefinition.id)
  scope: openAi
  properties: {
    roleDefinitionId: cognitiveServicesUserRoleDefinition.id
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Create federated identity for the user-defined managed identity used by the workload
resource federatedIdentityCredentials 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = if (!empty(namespace) && !empty(serviceAccountName)) {
  name: 'WorkloadFederatedIdentityCredentials'
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
