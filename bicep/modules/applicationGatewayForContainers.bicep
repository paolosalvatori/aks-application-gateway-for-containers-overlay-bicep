//********************************************
// Parameters
//********************************************

@description('Specifies the name of the Application Gateway for Containers.')
param name string = 'dummy'

@description('Specifies whether the Application Gateway for Containers is managed or bring your own (BYO).')
@allowed([
  'managed'
  'byo'
])
param type string = 'managed'

@description('Specifies the workspace id of the Log Analytics used to monitor the Application Gateway for Containers.')
param workspaceId string

@description('Specifies the location of the Application Gateway for Containers.')
param location string

@description('Specifies the name of the existing AKS cluster.')
param aksClusterName string

@description('Specifies the name of the AKS cluster node resource group. This needs to be passed as a parameter and cannot be calculated inside this module.')
param nodeResourceGroupName string

@description('Specifies the name of the existing virtual network.')
param virtualNetworkName string

@description('Specifies the name of the subnet which contains the Application Gateway for Containers.')
param subnetName string

@description('Specifies the namespace for the Application Load Balancer Controller of the Application Gateway for Containers.')
param namespace string = 'azure-alb-system'

@description('Specifies the name of the service account for the Application Load Balancer Controller of the Application Gateway for Containers.')
param serviceAccountName string = 'alb-controller-sa'

@description('Specifies the resource tags for the Application Gateway for Containers.')
param tags object

//********************************************
// Variables
//********************************************

var diagnosticSettingsName = 'diagnosticSettings'
var logCategories = [
  'TrafficControllerAccessLog'
]
var metricCategories = [
  'AllMetrics'
]
var logs = [for category in logCategories: {
  category: category
  enabled: true
}]
var metrics = [for category in metricCategories: {
  category: category
  enabled: true
}]

//********************************************
// Resources
//********************************************

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-10-02-preview' existing = {
  name: aksClusterName
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing =  {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' existing = {
  parent: virtualNetwork
  name: subnetName
}

resource readerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  name: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  scope: subscription()
}

resource networkContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  name: '4d97b98b-1d4f-4787-a291-c67834d212e7'
  scope: subscription()
}

resource appGwForContainersConfigurationManagerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  name: 'fbc52c3f-28ad-4303-a892-8a056630b8f1'
  scope: subscription()
}

resource applicationLoadBalancerManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: '${name}ManagedIdentity'
  location: location
  tags: tags
}

// Assign the Network Contributor role to the Application Load Balancer user-assigned managed identity with the association subnet as as scope
resource subnetnetworkContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name:  guid(name, applicationLoadBalancerManagedIdentity.name, networkContributorRoleDefinition.id)
  scope: subnet
  properties: {
    roleDefinitionId: networkContributorRoleDefinition.id
    principalId: applicationLoadBalancerManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Assign the AppGw for Containers Configuration Manager role to the Application Load Balancer user-assigned managed identity with the resource group as a scope
resource appGwForContainersConfigurationManagerRoleAssignmentOnResourceGroup 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (type == 'byo') {
  name:  guid(name, applicationLoadBalancerManagedIdentity.name, appGwForContainersConfigurationManagerRoleDefinition.id)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: appGwForContainersConfigurationManagerRoleDefinition.id
    principalId: applicationLoadBalancerManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Assign the AppGw for Containers Configuration Manager role to the Application Load Balancer user-assigned managed identity with the AKS cluster node resource group as a scope
module appGwForContainersConfigurationManagerRoleAssignmentOnnodeResourceGroupName 'resourceGroupRoleAssignment.bicep' = if (type == 'managed') {
  name: guid(nodeResourceGroupName, applicationLoadBalancerManagedIdentity.name, appGwForContainersConfigurationManagerRoleDefinition.id)
  scope: resourceGroup(nodeResourceGroupName)
  params: {
    principalId: applicationLoadBalancerManagedIdentity.properties.principalId
    roleName: appGwForContainersConfigurationManagerRoleDefinition.name
  }
}

// Assign the Reader role the Application Load Balancer user-assigned managed identity with the AKS cluster node resource group as a scope
module nodeResourceGroupreaderRoleAssignment 'resourceGroupRoleAssignment.bicep' = {
  name: guid(nodeResourceGroupName, applicationLoadBalancerManagedIdentity.name, readerRoleDefinition.id)
  scope: resourceGroup(nodeResourceGroupName)
  params: {
    principalId: applicationLoadBalancerManagedIdentity.properties.principalId
    roleName: readerRoleDefinition.name
  }
}

// Create federated identity for the Application Load Balancer user-assigned managed identity
resource federatedIdentityCredentials 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2024-11-30' = if (!empty(namespace) && !empty(serviceAccountName)) {
  name: 'azure-alb-identity'
  parent: applicationLoadBalancerManagedIdentity
  properties: {
    issuer: aksCluster.properties.oidcIssuerProfile.issuerURL
    subject: 'system:serviceaccount:${namespace}:${serviceAccountName}'
    audiences: [
      'api://AzureADTokenExchange'
    ]
  }
}

resource applicationGatewayForContainers 'Microsoft.ServiceNetworking/trafficControllers@2025-03-01-preview' = if (type == 'byo') {
  name: name
  location: location
  tags: tags
}

resource applicationGatewayDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (type == 'byo') {
  name: diagnosticSettingsName
  scope: applicationGatewayForContainers
  properties: {
    workspaceId: workspaceId
    logs: logs
    metrics: metrics
  }
}

//********************************************
// Outputs
//********************************************

output id string = applicationGatewayForContainers.id
output name string = applicationGatewayForContainers.name
output type string = applicationGatewayForContainers.type
output principalId string = applicationLoadBalancerManagedIdentity.properties.principalId
output clientId string = applicationLoadBalancerManagedIdentity.properties.clientId
