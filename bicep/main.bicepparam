using 'main.bicep'

// Parameters
param aksClusterNetworkMode = 'transparent'
param aksClusterNetworkDataplane = 'cilium'
param aksClusterNetworkPlugin = 'azure'
param aksClusterNetworkPluginMode = 'overlay'
param aksClusterNetworkPolicy = 'cilium'
param aksClusterWebAppRoutingEnabled = true
param aksClusterNginxDefaultIngressControllerType = 'Internal'
param aksClusterSkuTier = 'Standard'
param aksClusterPodCidr = '192.168.0.0/16'
param aksClusterServiceCidr = '172.16.0.0/16'
param aksClusterDnsServiceIP = '172.16.0.10'
param aksClusterOutboundType = 'userAssignedNATGateway'
param aksClusterKubernetesVersion = '1.30.4'
param aksClusterAdminUsername = 'azadmin'
param aksClusterSshPublicKey = '<YOUR_SSH_PUBLIC_KEY>'
param loadBalancerBackendPoolType = 'nodeIP'
param aadProfileManaged = true
param aadProfileEnableAzureRBAC = true
param aadProfileAdminGroupObjectIDs = [
  '<YOUR_AAD_GROUP_OBJECT_ID>'
]
param systemAgentPoolName = 'system'
param systemAgentPoolVmSize = 'Standard_F8s_v2'
param systemAgentPoolOsDiskSizeGB = 80
param systemAgentPoolAgentCount = 3
param systemAgentPoolMaxCount = 5
param systemAgentPoolMinCount = 3
param systemAgentPoolNodeTaints = [
  'CriticalAddonsOnly=true:NoSchedule'
]
param userAgentPoolName = 'user'
param userAgentPoolVmSize = 'Standard_F8s_v2'
param userAgentPoolOsDiskSizeGB = 80
param userAgentPoolAgentCount = 3
param userAgentPoolMaxCount = 5
param userAgentPoolMinCount = 3
param windowsAgentPoolEnabled = false
param windowsAgentPoolName = 'win'
param windowsAgentPoolAvailabilityZones = [
  '1'
  '2'
  '3'
]
param enableVnetIntegration = true
param virtualNetworkAddressPrefixes = '10.0.0.0/8'
param systemAgentPoolSubnetName = 'SystemSubnet'
param systemAgentPoolSubnetAddressPrefix = '10.240.0.0/16'
param userAgentPoolSubnetName = 'UserSubnet'
param userAgentPoolSubnetAddressPrefix = '10.241.0.0/16'
param podSubnetName = 'PodSubnet'
param podSubnetAddressPrefix = '10.242.0.0/16'
param apiServerSubnetName = 'ApiServerSubnet'
param apiServerSubnetAddressPrefix = '10.243.0.0/27'
param vmSubnetName = 'VmSubnet'
param vmSubnetAddressPrefix = '10.243.1.0/24'
param bastionSubnetAddressPrefix = '10.243.2.0/24'
param applicationGatewayForContainersSubnetName = 'AppGwForConSubnet'
param applicationGatewayForContainersSubnetAddressPrefix = '10.243.3.0/24'
param applicationGatewayForContainersEnabled = true
param applicationGatewayForContainersType = 'managed'
param logAnalyticsSku = 'PerGB2018'
param logAnalyticsRetentionInDays = 60
param vmEnabled = true
param vmName = 'TestVm'
param vmSize = 'Standard_F8s_v2'
param imagePublisher = 'Canonical'
param imageOffer = '0001-com-ubuntu-server-jammy'
param imageSku = '22_04-lts-gen2'
param authenticationType = 'sshPublicKey'
param vmAdminUsername = 'azadmin'
param vmAdminPasswordOrKey = '<YOUR_SSH_PUBLIC_KEY>'
param diskStorageAccountType = 'Premium_LRS'
param numDataDisks = 1
param osDiskSize = 50
param dataDiskSize = 50
param dataDiskCaching = 'ReadWrite'
param aksClusterEnablePrivateCluster = false
param aksEnablePrivateClusterPublicFQDN = false
param kedaEnabled = true
param daprEnabled = true
param fluxGitOpsEnabled = false
param verticalPodAutoscalerEnabled = true
param deploymentScriptUri = 'https://raw.githubusercontent.com/paolosalvatori/aks-application-gateway-for-containers-overlay-bicep/refs/heads/main/bicep/install-alb-controller-overlay.sh'
param blobCSIDriverEnabled = true
param diskCSIDriverEnabled = true
param fileCSIDriverEnabled = true
param snapshotControllerEnabled = true
param defenderSecurityMonitoringEnabled = true
param imageCleanerEnabled = true
param imageCleanerIntervalHours = 24
param nodeRestrictionEnabled = true
param workloadIdentityEnabled = true
param oidcIssuerProfileEnabled = true
param dnsZoneName = 'babosbird.com'
param dnsZoneResourceGroupName = 'DnsResourceGroup'
param actionGroupEmailAddress = '<YOUR-EMAIL-ADDRESS>'
param email = '<YOUR-EMAIL-ADDRESS>'
param workloadManagedIdentityEnabled = true
param prometheusAndGrafanaEnabled = true
param gatewayName = 'httpbin-gateway'
param namespace = 'httpbin'
param clusterTags = {
  iaC: 'Bicep'
  apiServerVnetIntegration: true
  podSubnet: false
  perAgentPoolSubnet: true
  networkPolicy: 'Cilium'
  networkPlugin: 'Azure'
  networkDataplane: 'Cilium'
  networkPluginMode: 'Overlay'
}
param openAiEnabled = false
param openAiDeployments = [
  {
    model: {
      name: 'text-embedding-ada-002'
      version: '2'
    }
    sku: {
      name: 'Standard'
      capacity: 10
    }
  }
  {
    model: {
      name: 'gpt-4o'
      version: '2024-05-13'
    }
    sku: {
      name: 'GlobalStandard'
      capacity: 10
    }
  }
]

