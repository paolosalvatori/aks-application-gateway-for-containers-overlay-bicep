//********************************************
// Parameters
//********************************************

@description('Specifies the name of the deployment script uri.')
param name string = 'BashScript' 

@description('Specifies the Azure CLI module version.')
param azCliVersion string = '2.52.0'

@description('Specifies the clean up preference when the script execution gets in a terminal state. Default setting is Always.')
@allowed([
  'Always'
  'OnExpiration'
  'OnSuccess'
])
param cleanupPreference string = 'OnSuccess'

@description('Specifies the interval for which the service retains the script resource after it reaches a terminal state. Resource will be deleted when this duration expires.')
param retentionInterval string = 'P1D'

@description('Specifies whether to deploy Prometheus and Grafana to the AKS cluster using a Helm chart.')
param deployPrometheusAndGrafanaViaHelm bool = true

@description('Specifies whether to whether to deploy the Certificate Manager to the AKS cluster using a Helm chart.')
param deployCertificateManagerViaHelm bool = true

@description('Specifies the list of ingress classes for which a cert-manager cluster issuer should be created.')
param ingressClassNames array = ['nginx', 'webapprouting.kubernetes.azure.com']

@description('Specifies the list of the names for the cert-manager cluster issuers.')
param clusterIssuerNames array = ['letsencrypt-nginx', 'letsencrypt-webapprouting']

@description('Specifies whether and how to deploy the NGINX Ingress Controller to the AKS cluster using a Helm chart. Possible values are None, Internal, and External.')
@allowed([
  'None'
  'Internal'
  'External'
])
param deployNginxIngressControllerViaHelm string = 'External'

@description('Specifies the name of the storage account used by the deployment script.')
param storageAccountName string = 'serverboot${uniqueString(resourceGroup().id)}'

@description('Specifies the resource id of the user-defined managed identity used by the deployment script.')
param managedIdentityId string 

@description('Specifies the primary script URI.')
param primaryScriptUri string

@description('Specifies the name of the AKS cluster.')
param clusterName string

@description('Specifies the resource group name')
param resourceGroupName string = resourceGroup().name

@description('Specifies the name of the AKS node resource group')
param nodeResourceGroupName string = resourceGroup().name

@description('Specifies the Azure AD tenant id.')
param tenantId string = subscription().tenantId

@description('Specifies the subscription id.')
param subscriptionId string = subscription().subscriptionId

@description('Specifies the service account of the application.')
param serviceAccountName string = ''

@description('Specifies the client id of the workload user-defined managed identity.')
param workloadManagedIdentityClientId string

@description('Specifies whether the Application Gateway for Containers is managed or bring your own (BYO).')
@allowed([
  'managed'
  'byo'
])
param applicationGatewayForContainersType string

@description('Specifies whether creating an Application Gateway for Containers or not.')
param applicationGatewayForContainersEnabled string

@description('Specifies the namespace of the Application Load Balancer controller.')
param applicationGatewayForContainersNamespace string = 'azure-alb-system'

@description('Specifies the client id of the user-defined managed identity of the Application Gateway for Containers.')
param applicationGatewayForContainersManagedIdentityClientId string = ''

@description('Specifies the resource id of the subnet which contains the Application Gateway for Containers.')
param applicationGatewayForContainersSubnetId string = ''

@description('Specifies the helm chart version of the Application Gateway for Containers.')
param applicationGatewayForContainersHelmChartVersion string = '1.5.2'

@description('Specifies the name of an existing public DNS zone.')
param dnsZoneName string

@description('Specifies the name of the resource group which contains the public DNS zone.')
param dnsZoneResourceGroupName string

@description('Specifies the name of the client id of the certificate manager user-assigned managed identity.')
param certificateManagerManagedIdentityClientId string

@description('Specifies the workspace id of the Log Analytics used to monitor the Application Gateway for Containers.')
param workspaceId string

@description('Specifies the name of the gateway.')
param gatewayName string

@description('Specifies the namespace of the application.')
param namespace string

@description('Specifies the email address for the cert-manager cluster issuer.')
param email string

@description('Specifies the current datetime')
param utcValue string = utcNow()

@description('Specifies the location.')
param location string

@description('Specifies the resource tags.')
param tags object

//********************************************
// Resources
//********************************************

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' existing = {
  name: storageAccountName
}

// Script
resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: name
  location: location
  kind: 'AzureCLI'
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityId}': {}
    }
  }
  properties: {
    forceUpdateTag: utcValue
    azCliVersion: azCliVersion
    timeout: 'PT30M'
    environmentVariables: [
      {
        name: 'clusterName'
        value: clusterName
      }
      {
        name: 'resourceGroupName'
        value: resourceGroupName
      }
      {
        name: 'nodeResourceGroupName'
        value: nodeResourceGroupName
      }
      {
        name: 'tenantId'
        value: tenantId
      }
      {
        name: 'subscriptionId'
        value: subscriptionId
      }
      {
        name: 'workspaceId'
        value: workspaceId
      }
      {
        name: 'gatewayName'
        value: gatewayName
      }
      {
        name: 'namespace'
        value: namespace
      }
      {
        name: 'serviceAccountName'
        value: serviceAccountName
      }
      {
        name: 'deployPrometheusAndGrafanaViaHelm'
        value: deployPrometheusAndGrafanaViaHelm ? 'true' : 'false'
      }
      {
        name: 'ingressClassNames'
        value: join(ingressClassNames, ',')
      }
      {
        name: 'clusterIssuerNames'
        value: join(clusterIssuerNames, ',')
      }
      {
        name: 'deployCertificateManagerViaHelm'
        value: deployCertificateManagerViaHelm ? 'true' : 'false'
      }
      {
        name: 'deployNginxIngressControllerViaHelm'
        value: deployNginxIngressControllerViaHelm
      }
      {
        name: 'dnsZoneName'
        value: dnsZoneName
      }
      {
        name: 'dnsZoneResourceGroupName'
        value: dnsZoneResourceGroupName
      }
      {
        name: 'certificateManagerManagedIdentityClientId'
        value: certificateManagerManagedIdentityClientId
      }
      {
        name: 'workloadManagedIdentityClientId'
        value: workloadManagedIdentityClientId
      }
      {
        name: 'applicationGatewayForContainersType'
        value: applicationGatewayForContainersType
      }
      {
        name: 'applicationGatewayForContainersEnabled'
        value: applicationGatewayForContainersEnabled
      }
      {
        name: 'applicationGatewayForContainersNamespace'
        value: applicationGatewayForContainersNamespace}
      {
        name: 'applicationGatewayForContainersManagedIdentityClientId'
        value: applicationGatewayForContainersManagedIdentityClientId
      }
      {
        name: 'applicationGatewayForContainersSubnetId'
        value: applicationGatewayForContainersSubnetId
      }
      {
        name: 'applicationGatewayForContainersName'
        value: '${clusterName}-appgw'
      }
      {
        name: 'applicationGatewayForContainersManagedIdentityName'
        value: '${clusterName}-appgw-mi'
      }
      {
        name: 'applicationGatewayForContainersHelmChartName'
        value: 'application-gateway-kubernetes-ingress'
      }
      {
        name: 'applicationGatewayForContainersHelmChartVersion'
        value: applicationGatewayForContainersHelmChartVersion
      }
      {
        name: 'email'
        value: email
      }
    ]
    storageAccountSettings: {
      storageAccountName: storageAccount.name
      storageAccountKey: storageAccount.listKeys().keys[0].value
    }
    primaryScriptUri: primaryScriptUri
    cleanupPreference: cleanupPreference
    retentionInterval: retentionInterval
  }
}

//********************************************
// Outputs
//********************************************

output result object = deploymentScript.properties.outputs
output certManager string = deploymentScript.properties.outputs.certManager
output nginxIngressController string = deploymentScript.properties.outputs.nginxIngressController
output applicationGatewayForContainersName string = deploymentScript.properties.outputs.applicationGatewayForContainersName
