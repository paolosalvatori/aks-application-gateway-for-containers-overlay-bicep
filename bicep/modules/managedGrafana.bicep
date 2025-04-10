//********************************************
// Parameters
//********************************************

@description('Specifies the name of the Azure Monitor managed service for Prometheus resource.')
param prometheusName string

@description('Specifies the name of the Azure Managed Grafana resource.')
param name string

@description('Specifies the location of the Azure Managed Grafana resource.')
param location string = resourceGroup().location

@description('Specifies the sku of the Azure Managed Grafana resource.')
param skuName string = 'Standard'

@description('Specifies the api key setting of the Azure Managed Grafana resource.')
@allowed([
  'Disabled'
  'Enabled'
])
param apiKey string = 'Enabled'

@description('Specifies the scope for dns deterministic name hash calculation.')
@allowed([
  'TenantReuse'
])
param autoGeneratedDomainNameLabelScope string = 'TenantReuse'

@description('Specifies whether the Azure Managed Grafana resource uses deterministic outbound IPs.')
@allowed([
  'Disabled'
  'Enabled'
])
param deterministicOutboundIP string = 'Disabled'

@description('Specifies the the state for enable or disable traffic over the public interface for the the Azure Managed Grafana resource.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccess	string = 'Enabled' 

@description('The zone redundancy setting of the Azure Managed Grafana resource.')
@allowed([
  'Disabled'
  'Enabled'
])
param zoneRedundancy string = 'Disabled'

@description('Specifies the object id of an Azure Active Directory user. In general, this the object id of the system administrator who deploys the Azure resources.')
param userId string = ''

@description('Specifies the resource tags for the Azure Monitor managed service for Prometheus resource.')
param tags object

//********************************************
// Resources
//********************************************

resource mmonitoringReaderRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  scope: subscription()
}

resource monitoringDataReaderRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b0d8363b-8ddd-447d-831f-62ca05bff136'
  scope: subscription()
}

resource grafanaAdminRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '22926164-76b3-42b3-bc55-97df8dab3e41'
  scope: subscription()
}

resource managedPrometheus 'Microsoft.Monitor/accounts@2023-10-01-preview' existing = {
  name: prometheusName
}

resource managedGrafana 'Microsoft.Dashboard/grafana@2023-09-01' =  {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    apiKey: apiKey
    autoGeneratedDomainNameLabelScope: autoGeneratedDomainNameLabelScope
    deterministicOutboundIP: deterministicOutboundIP
    grafanaIntegrations: {
      azureMonitorWorkspaceIntegrations: [{
        azureMonitorWorkspaceResourceId: managedPrometheus.id
      }]
    }
    publicNetworkAccess: publicNetworkAccess
    zoneRedundancy: zoneRedundancy
  }
}

// Assign the Monitoring Reader role to the Azure Managed Grafana system-assigned managed identity at the workspace scope
resource monitoringReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name:  guid(name, managedPrometheus.name, mmonitoringReaderRole.id)
  scope: managedPrometheus
  properties: {
    roleDefinitionId: mmonitoringReaderRole.id
    principalId: managedGrafana.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

// Assign the Monitoring Data Reader role to the Azure Managed Grafana system-assigned managed identity at the workspace scope
resource monitoringDataReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name:  guid(name, managedPrometheus.name, monitoringDataReaderRole.id)
  scope: managedPrometheus
  properties: {
    roleDefinitionId: monitoringDataReaderRole.id
    principalId: managedGrafana.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

// Assign the Grafana Admin role to the Microsoft Entra ID user at the Azure Managed Grafana resource scope
resource grafanaAdminRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(userId)) {
  name:  guid(name, userId, grafanaAdminRole.id)
  scope: managedGrafana
  properties: {
    roleDefinitionId: grafanaAdminRole.id
    principalId: userId
    principalType: 'User'
  }
}

//********************************************
// Outputs
//********************************************

output id string = managedGrafana.id
output name string = managedGrafana.name
output location string = managedGrafana.location
output principalId string = managedGrafana.identity.principalId
