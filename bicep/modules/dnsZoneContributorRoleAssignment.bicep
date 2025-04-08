//********************************************
// Parameters
//********************************************

@description('Specifies the principal id of the user-defined managed identity used by the certificate manager.')
param principalId string

@description('Specifies the name of an existing public DNS zone.')
param dnsZoneName string

//********************************************
// Resources
//********************************************

resource dnsZoneContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  name: 'befefa01-2a29-4197-83a8-272ff33ce314'
  scope: subscription()
}

resource dnsZone 'Microsoft.Network/dnsZones@2023-07-01-preview' existing = if (!empty(dnsZoneName)) {
  name: dnsZoneName
}

resource dnsZoneContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(dnsZoneName)) {
  name:  guid(dnsZone.id, principalId, dnsZoneContributorRoleDefinition.id)
  scope: dnsZone
  properties: {
    roleDefinitionId: dnsZoneContributorRoleDefinition.id
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
