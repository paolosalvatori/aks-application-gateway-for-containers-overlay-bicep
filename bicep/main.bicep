//********************************************
// Parameters
//********************************************

@description('Specifies the name prefix.')
@minLength(3)
param prefix string = '$uniqueString(resourceGroup().id)'

@description('Specifies the object id of an Azure Active Directory user. In general, this the object id of the system administrator who deploys the Azure resources.')
param userId string = ''

@description('Specifies whether name resources are in CamelCase, UpperCamelCase, or KebabCase.')
@allowed([
  'CamelCase'
  'UpperCamelCase'
  'KebabCase'
])
param letterCaseType string = 'UpperCamelCase'

@description('Specifies the location of the AKS cluster.')
param location string = resourceGroup().location

@description('Specifies the name of the AKS cluster.')
param aksClusterName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Aks'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Aks' : '${toLower(prefix)}-aks'

@description('Specifies whether creating metric alerts or not.')
param createMetricAlerts bool = true

@description('Specifies whether metric alerts as either enabled or disabled.')
param metricAlertsEnabled bool = true

@description('Specifies metric alerts eval frequency.')
param metricAlertsEvalFrequency string = 'PT1M'

@description('Specifies metric alerts window size.')
param metricAlertsWindowsSize string = 'PT1H'

@description('Specifies the name of AKS user-assigned managed identity.')
param aksManagedIdentityName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}AksManagedIdentity'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}AksManagedIdentity' : '${toLower(prefix)}-aks-managed-identity'

@description('Specifies the DNS prefix specified when creating the managed cluster.')
param aksClusterDnsPrefix string = aksClusterName

@description('Specifies the network plugin used for building Kubernetes network. - azure or kubenet.')
@allowed([
  'azure'
  'kubenet'
])
param aksClusterNetworkPlugin string = 'azure'

@description('Specifies the Network plugin mode used for building the Kubernetes network.')
@allowed([
  ''
  'overlay'
])
param aksClusterNetworkPluginMode string = ''

@description('Specifies the network policy used for building Kubernetes network. - calico or azure')
@allowed([
  'azure'
  'calico'
  'cilium'
  'none'
])
param aksClusterNetworkPolicy string = 'azure'

@description('Specifies the network dataplane used in the Kubernetes cluster..')
@allowed([
  'azure'
  'cilium'
])
param aksClusterNetworkDataplane string = 'azure'

@description('Specifies the network mode. This cannot be specified if networkPlugin is anything other than azure.')
@allowed([
  'bridge'
  'transparent'
])
param aksClusterNetworkMode string = 'transparent'

@description('Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used.')
param aksClusterPodCidr string = '192.168.0.0/16'

@description('A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges.')
param aksClusterServiceCidr string = '172.16.0.0/16'

@description('Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr.')
param aksClusterDnsServiceIP string = '172.16.0.10'

@description('Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools.')
@allowed([
  'basic'
  'standard'
])
param aksClusterLoadBalancerSku string = 'standard'

@description('Specifies the type of the managed inbound Load Balancer BackendPool.')
@allowed([
  'nodeIP'
  'nodeIPConfiguration'
])
param loadBalancerBackendPoolType string = 'nodeIPConfiguration'

@description('Specifies Advanced Networking profile for enabling observability on a cluster. Note that enabling advanced networking features may incur additional costs. For more information see aka.ms/aksadvancednetworking.')
param advancedNetworking object = {
  enabled: true
  observability: {
    enabled: true
  }
  security: aksClusterNetworkDataplane == 'cilium'
    ? {
        enabled: true
      }
    : null
}

@description('Specifies the IP families are used to determine single-stack or dual-stack clusters. For single-stack, the expected value is IPv4. For dual-stack, the expected values are IPv4 and IPv6.')
param aksClusterIpFamilies array = ['IPv4']

@description('Specifies outbound (egress) routing method. - loadBalancer or userDefinedRouting.')
@allowed([
  'loadBalancer'
  'managedNATGateway'
  'userAssignedNATGateway'
  'userDefinedRouting'
])
param aksClusterOutboundType string = 'loadBalancer'

@description('Specifies the tier of a managed cluster SKU: Paid or Free')
@allowed([
  'Free'
  'Standard'
  'Premium'
])
param aksClusterSkuTier string = 'Standard'

@description('Specifies the version of Kubernetes specified when creating the managed cluster.')
param aksClusterKubernetesVersion string = '1.18.8'

@description('Specifies the administrator username of Linux virtual machines.')
param aksClusterAdminUsername string = 'azureuser'

@description('Specifies the SSH RSA public key string for the Linux nodes.')
param aksClusterSshPublicKey string

@description('Specifies the tenant id of the Azure Active Directory used by the AKS cluster for authentication.')
param aadProfileTenantId string = subscription().tenantId

@description('Specifies the AAD group object IDs that will have admin role of the cluster.')
param aadProfileAdminGroupObjectIDs array = []

@description('Specifies the node OS upgrade channel. The default is Unmanaged, but may change to either NodeImage or SecurityPatch at GA.	.')
@allowed([
  'NodeImage'
  'None'
  'SecurityPatch'
  'Unmanaged'
])
param aksClusterNodeOSUpgradeChannel string = 'Unmanaged'

@description('Specifies the upgrade channel for auto upgrade. Allowed values include rapid, stable, patch, node-image, none.')
@allowed([
  'rapid'
  'stable'
  'patch'
  'node-image'
  'none'
])
param aksClusterUpgradeChannel string = 'stable'

@description('Specifies whether to create the cluster as a private cluster or not.')
param aksClusterEnablePrivateCluster bool = true

@description('Specifies whether the managed NGINX Ingress Controller application routing addon is enabled.')
param aksClusterWebAppRoutingEnabled bool = true

@description('Specifies the ingress type for the default NginxIngressController custom resource.')
@allowed([
  'AnnotationControlled'
  'External'
  'Internal'
  'None'
])
param aksClusterNginxDefaultIngressControllerType string = 'Internal'

@description('Specifies the Private DNS Zone mode for private cluster. When the value is equal to None, a Public DNS Zone is used in place of a Private DNS Zone')
param aksPrivateDNSZone string = 'none'

@description('Specifies whether to create additional public FQDN for private cluster or not.')
param aksEnablePrivateClusterPublicFQDN bool = true

@description('Specifies whether to enable managed AAD integration.')
param aadProfileManaged bool = true

@description('Specifies whether to  to enable Azure RBAC for Kubernetes authorization.')
param aadProfileEnableAzureRBAC bool = true

@description('Specifies the unique name of of the system node pool profile in the context of the subscription and resource group.')
param systemAgentPoolName string = 'nodepool1'

@description('Specifies the vm size of nodes in the system node pool.')
param systemAgentPoolVmSize string = 'Standard_DS5_v2'

@description('Specifies the OS Disk Size in GB to be used to specify the disk size for every machine in the system agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified.')
param systemAgentPoolOsDiskSizeGB int = 100

@description('Specifies the OS disk type to be used for machines in a given agent pool. Allowed values are \'Ephemeral\' and \'Managed\'. If unspecified, defaults to \'Ephemeral\' when the VM supports ephemeral OS and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to \'Managed\'. May not be changed after creation. - Managed or Ephemeral')
@allowed([
  'Ephemeral'
  'Managed'
])
param systemAgentPoolOsDiskType string = 'Ephemeral'

@description('Specifies the number of agents (VMs) to host docker containers in the system node pool. Allowed values must be in the range of 1 to 100 (inclusive). The default value is 1.')
param systemAgentPoolAgentCount int = 3

@description('Specifies the OS type for the vms in the system node pool. Choose from Linux and Windows. Default to Linux.')
@allowed([
  'Linux'
  'Windows'
])
param systemAgentPoolOsType string = 'Linux'

@description('Specifies the OS SKU used by the system agent pool. If not specified, the default is Ubuntu if OSType=Linux or Windows2019 if OSType=Windows. And the default Windows OSSKU will be changed to Windows2022 after Windows2019 is deprecated.')
@allowed([
  'Ubuntu'
  'Windows2019'
  'Windows2022'
  'AzureLinux'
])
param systemAgentPoolOsSKU string = 'Ubuntu'

@description('Specifies the maximum number of pods that can run on a node in the system node pool. The maximum number of pods per node in an AKS cluster is 250. The default maximum number of pods per node varies between kubenet and Azure CNI networking, and the method of cluster deployment.')
param systemAgentPoolMaxPods int = 30

@description('Specifies the maximum number of nodes for auto-scaling for the system node pool.')
param systemAgentPoolMaxCount int = 5

@description('Specifies the minimum number of nodes for auto-scaling for the system node pool.')
param systemAgentPoolMinCount int = 3

@description('Specifies whether to enable auto-scaling for the system node pool.')
param systemAgentPoolEnableAutoScaling bool = true

@description('Specifies the virtual machine scale set priority in the system node pool: Spot or Regular.')
@allowed([
  'Spot'
  'Regular'
])
param systemAgentPoolScaleSetPriority string = 'Regular'

@description('Specifies the ScaleSetEvictionPolicy to be used to specify eviction policy for spot virtual machine scale set. Default to Delete. Allowed values are Delete or Deallocate.')
@allowed([
  'Delete'
  'Deallocate'
])
param systemAgentPoolScaleSetEvictionPolicy string = 'Delete'

@description('Specifies the Agent pool node labels to be persisted across all nodes in the system node pool.')
param systemAgentPoolNodeLabels object = {}

@description('Specifies the taints added to new nodes during node pool create and scale. For example, key=value:NoSchedule.')
param systemAgentPoolNodeTaints array = []

@description('Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage.')
@allowed([
  'OS'
  'Temporary'
])
param systemAgentPoolKubeletDiskType string = 'OS'

@description('Specifies the type for the system node pool: VirtualMachineScaleSets or AvailabilitySet')
@allowed([
  'VirtualMachineScaleSets'
  'AvailabilitySet'
])
param systemAgentPoolType string = 'VirtualMachineScaleSets'

@description('Specifies the availability zones for the agent nodes in the system node pool. Requirese the use of VirtualMachineScaleSets as node pool type.')
param systemAgentPoolAvailabilityZones array = [
  '1'
  '2'
  '3'
]

@description('Specifies the unique name of of the user node pool profile in the context of the subscription and resource group.')
param userAgentPoolName string = 'nodepool1'

@description('Specifies the vm size of nodes in the user node pool.')
param userAgentPoolVmSize string = 'Standard_DS5_v2'

@description('Specifies the OS Disk Size in GB to be used to specify the disk size for every machine in the system agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified..')
param userAgentPoolOsDiskSizeGB int = 100

@description('Specifies the OS disk type to be used for machines in a given agent pool. Allowed values are \'Ephemeral\' and \'Managed\'. If unspecified, defaults to \'Ephemeral\' when the VM supports ephemeral OS and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to \'Managed\'. May not be changed after creation. - Managed or Ephemeral')
@allowed([
  'Ephemeral'
  'Managed'
])
param userAgentPoolOsDiskType string = 'Ephemeral'

@description('Specifies the number of agents (VMs) to host docker containers in the user node pool. Allowed values must be in the range of 1 to 100 (inclusive). The default value is 1.')
param userAgentPoolAgentCount int = 3

@description('Specifies the OS type for the vms in the user node pool. Choose from Linux and Windows. Default to Linux.')
@allowed([
  'Linux'
  'Windows'
])
param userAgentPoolOsType string = 'Linux'

@description('Specifies the OS SKU used by the system agent pool. If not specified, the default is Ubuntu if OSType=Linux or Windows2019 if OSType=Windows. And the default Windows OSSKU will be changed to Windows2022 after Windows2019 is deprecated.')
@allowed([
  'Ubuntu'
  'Windows2019'
  'Windows2022'
  'AzureLinux'
])
param userAgentPoolOsSKU string = 'Ubuntu'

@description('Specifies the maximum number of pods that can run on a node in the user node pool. The maximum number of pods per node in an AKS cluster is 250. The default maximum number of pods per node varies between kubenet and Azure CNI networking, and the method of cluster deployment.')
param userAgentPoolMaxPods int = 30

@description('Specifies the maximum number of nodes for auto-scaling for the user node pool.')
param userAgentPoolMaxCount int = 5

@description('Specifies the minimum number of nodes for auto-scaling for the user node pool.')
param userAgentPoolMinCount int = 3

@description('Specifies whether to enable auto-scaling for the user node pool.')
param userAgentPoolEnableAutoScaling bool = true

@description('Specifies the virtual machine scale set priority in the user node pool: Spot or Regular.')
@allowed([
  'Spot'
  'Regular'
])
param userAgentPoolScaleSetPriority string = 'Regular'

@description('Specifies the ScaleSetEvictionPolicy to be used to specify eviction policy for spot virtual machine scale set. Default to Delete. Allowed values are Delete or Deallocate.')
@allowed([
  'Delete'
  'Deallocate'
])
param userAgentPoolScaleSetEvictionPolicy string = 'Delete'

@description('Specifies the Agent pool node labels to be persisted across all nodes in the user node pool.')
param userAgentPoolNodeLabels object = {}

@description('Specifies the taints added to new nodes during node pool create and scale. For example, key=value:NoSchedule.')
param userAgentPoolNodeTaints array = []

@description('Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage.')
@allowed([
  'OS'
  'Temporary'
])
param userAgentPoolKubeletDiskType string = 'OS'

@description('Specifies the type for the user node pool: VirtualMachineScaleSets or AvailabilitySet')
@allowed([
  'VirtualMachineScaleSets'
  'AvailabilitySet'
])
param userAgentPoolType string = 'VirtualMachineScaleSets'

@description('Specifies the availability zones for the agent nodes in the user node pool. Requirese the use of VirtualMachineScaleSets as node pool type.')
param userAgentPoolAvailabilityZones array = [
  '1'
  '2'
  '3'
]

@description('Specifies whether the httpApplicationRouting add-on is enabled or not.')
param httpApplicationRoutingEnabled bool = false

@description('Specifies whether the Istio Service Mesh add-on is enabled or not.')
param istioServiceMeshEnabled bool = false

@description('Specifies whether the Istio Ingress Gateway is enabled or not.')
param istioIngressGatewayEnabled bool = false

@description('Specifies the type of the Istio Ingress Gateway.')
@allowed([
  'Internal'
  'External'
])
param istioIngressGatewayType string = 'External'

@description('Specifies whether the Kubernetes Event-Driven Autoscaler (KEDA) add-on is enabled or not.')
param kedaEnabled bool = false

@description('Specifies whether the Dapr extension is enabled or not.')
param daprEnabled bool = false

@description('Enable high availability (HA) mode for the Dapr control plane')
param daprHaEnabled bool = false

@description('Specifies whether the Flux V2 extension is enabled or not.')
param fluxGitOpsEnabled bool = false

@description('Specifies whether the Vertical Pod Autoscaler is enabled or not.')
param verticalPodAutoscalerEnabled bool = false

@description('Specifies whether the aciConnectorLinux add-on is enabled or not.')
param aciConnectorLinuxEnabled bool = false

@description('Specifies whether the azurepolicy add-on is enabled or not.')
param azurePolicyEnabled bool = true

@description('Specifies whether the Azure Key Vault Provider for Secrets Store CSI Driver addon is enabled or not.')
param azureKeyvaultSecretsProviderEnabled bool = true

@description('Specifies whether the kubeDashboard add-on is enabled or not.')
param kubeDashboardEnabled bool = false

@description('Specifies the scan interval of the auto-scaler of the AKS cluster.')
param autoScalerProfileScanInterval string = '10s'

@description('Specifies the scale down delay after add of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownDelayAfterAdd string = '10m'

@description('Specifies the scale down delay after delete of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownDelayAfterDelete string = '20s'

@description('Specifies scale down delay after failure of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownDelayAfterFailure string = '3m'

@description('Specifies the scale down unneeded time of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownUnneededTime string = '10m'

@description('Specifies the scale down unready time of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownUnreadyTime string = '20m'

@description('Specifies the utilization threshold of the auto-scaler of the AKS cluster.')
param autoScalerProfileUtilizationThreshold string = '0.5'

@description('Specifies the max graceful termination time interval in seconds for the auto-scaler of the AKS cluster.')
param autoScalerProfileMaxGracefulTerminationSec string = '600'

@description('Specifies whether to enable API server VNET integration for the cluster or not.')
param enableVnetIntegration bool = true

@description('Specifies whether to create a Windows agent pool.')
param windowsAgentPoolEnabled bool = false

@description('Specifies the name of the agent pool.')
param windowsAgentPoolName string = 'win'

@description('Specifies the mode of the agent pool.')
@allowed([
  'System'
  'User'
])
param windowsAgentPoolMode string = 'User'

@description('Specifies the availability zones for the agent pool.')
param windowsAgentPoolAvailabilityZones array = ['1', '2', '3']

@description('Specifies thr OS disk type of the agent pool.')
param windowsAgentPoolOsDiskType string = 'Ephemeral'

@description('Specifies the VM sku of the agent nodes.')
param windowsAgentPoolVmSize string = 'Standard_DS5_v2'

@description('Specifies the disk size in GB of the agent nodes.')
param windowsAgentPoolOsDiskSizeGB int = 100

@description('Specifies the number of agents for the user agent pool')
param windowsAgentPoolCount int = 1

@description('Specifies the minimum number of nodes for the user agent pool.')
param windowsAgentPoolMinCount int = 3

@description('Specifies the maximum number of nodes for the user agent pool.')
param windowsAgentPoolMaxCount int = 3

@description('Specifies the maximum number of pods per node.')
param windowsAgentPoolMaxPods int = 30

@description('Specifies the taints that should be applied to the agent pool.')
param windowsAgentPoolNodeTaints array = ['os=windows:NoSchedule']

@description('Specifies the labels that should be applied to the agent pool.')
param windowsAgentPoolNodeLabels object = {}

@description('Specifies the OS Type for the agent pool.')
@allowed([
  'Linux'
  'Windows'
])
param windowsAgentPoolOsType string = 'Windows'

@allowed([
  'Ubuntu'
  'Windows2019'
  'Windows2022'
  'AzureLinux'
])
param windowsAgentPoolOsSKU string = 'Windows2022'

@description('Specifies whether assign a public IP per agent node.')
param windowsAgentPoolEnableNodePublicIP bool = false

@description('Specifies whether to enable auto-scaling for the agent pool.')
param windowsAgentPoolEnableAutoScaling bool = true

@description('Specifies the name of the virtual network.')
param virtualNetworkName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Vnet'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Vnet' : '${toLower(prefix)}-vnet'

@description('Specifies the address prefixes of the virtual network.')
param virtualNetworkAddressPrefixes string = '10.0.0.0/8'

@description('Specifies the name of the subnet hosting the worker nodes of the default system agent pool of the AKS cluster.')
param systemAgentPoolSubnetName string = 'SystemSubnet'

@description('Specifies the address prefix of the subnet hosting the worker nodes of the default system agent pool of the AKS cluster.')
param systemAgentPoolSubnetAddressPrefix string = '10.0.0.0/16'

@description('Specifies the name of the subnet hosting the worker nodes of the user agent pool of the AKS cluster.')
param userAgentPoolSubnetName string = 'UserSubnet'

@description('Specifies the address prefix of the subnet hosting the worker nodes of the user agent pool of the AKS cluster.')
param userAgentPoolSubnetAddressPrefix string = '10.1.0.0/16'

@description('Specifies the address prefix of the subnet hosting the pods running in the AKS cluster.')
param windowsAgentPoolSubnetName string = 'WindowsSubnet'

@description('Specifies the address prefix of the subnet hosting the pods running in the AKS cluster.')
param windowsAgentPoolSubnetAddressPrefix string = '10.4.0.0/16'

@description('Specifies whether to enable the Azure Blob CSI Driver. The default value is false.')
param blobCSIDriverEnabled bool = false

@description('Specifies whether to enable the Azure Disk CSI Driver. The default value is true.')
param diskCSIDriverEnabled bool = true

@description('Specifies whether to enable the Azure File CSI Driver. The default value is true.')
param fileCSIDriverEnabled bool = true

@description('Specifies whether to enable the Snapshot Controller. The default value is true.')
param snapshotControllerEnabled bool = true

@description('Specifies whether to enable Defender threat detection. The default value is false.')
param defenderSecurityMonitoringEnabled bool = false

@description('Specifies whether to enable ImageCleaner on AKS cluster. The default value is false.')
param imageCleanerEnabled bool = false

@description('Specifies whether ImageCleaner scanning interval in hours.')
param imageCleanerIntervalHours int = 24

@description('Specifies whether to enable Node Restriction. The default value is false.')
param nodeRestrictionEnabled bool = false

@description('Specifies whether to enable Workload Identity. The default value is false.')
param workloadIdentityEnabled bool = true

@description('Specifies whether the OIDC issuer is enabled.')
param oidcIssuerProfileEnabled bool = true

@description('Specifies whether the workload managed identity is enabled.')
param workloadManagedIdentityEnabled bool = false

@description('Specifies the name of the workload user-assigned managed identity.')
param workloadManagedIdentityName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}WorkloadManagedIdentity'
  : letterCaseType == 'CamelCase'
      ? '${toLower(prefix)}WorkloadManagedIdentity'
      : '${toLower(prefix)}-workload-managed-identity'

@description('Specifies the name of the subnet hosting the pods running in the AKS cluster.')
param podSubnetName string = letterCaseType == 'UpperCamelCase'
  ? 'PodSubnet'
  : letterCaseType == 'CamelCase' ? 'podSubnet' : 'pod-subnet'

@description('Specifies the address prefix of the subnet hosting the pods running in the AKS cluster.')
param podSubnetAddressPrefix string = '10.2.0.0/16'

@description('Specifies the name of the subnet delegated to the API server when configuring the AKS cluster to use API server VNET integration.')
param apiServerSubnetName string = letterCaseType == 'UpperCamelCase'
  ? 'ApiServerSubnet'
  : letterCaseType == 'CamelCase' ? 'apiServerSubnet' : 'api-server-subnet'

@description('Specifies the address prefix of the subnet delegated to the API server when configuring the AKS cluster to use API server VNET integration.')
param apiServerSubnetAddressPrefix string = '10.3.0.0/28'

@description('Specifies the name of the subnet which contains the virtual machine.')
param vmSubnetName string = letterCaseType == 'UpperCamelCase'
  ? 'VmSubnet'
  : letterCaseType == 'CamelCase' ? 'vmSubnet' : 'vm-subnet'

@description('Specifies the address prefix of the subnet which contains the virtual machine.')
param vmSubnetAddressPrefix string = '10.3.1.0/24'

@description('Specifies the Bastion subnet IP prefix. This prefix must be within vnet IP prefix address space.')
param bastionSubnetAddressPrefix string = '10.3.2.0/24'

@description('Specifies the name of the subnet which contains the Application Gateway for Containers.')
param applicationGatewayForContainersSubnetName string = 'AppGwForConSubnet'

@description('Specifies the address prefix of the subnet which contains the Application Gateway for Containers.')
param applicationGatewayForContainersSubnetAddressPrefix string = '10.3.4.0/24'

@description('Specifies the namespace for the Application Load Balancer Controller of the Application Gateway for Containers.')
param applicationGatewayForContainersAlbControllerNamespace string = 'azure-alb-system'

@description('Specifies the name of the service account for the Application Load Balancer Controller of the Application Gateway for Containers.')
param applicationGatewayForContainersAlbControllerServiceAccountName string = 'alb-controller-sa'

@description('Specifies the helm chart version of the Application Gateway for Containers.')
param applicationGatewayForContainersHelmChartVersion string = '1.5.2'

@description('Specifies the name of the Log Analytics Workspace.')
param logAnalyticsWorkspaceName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Workspace'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Workspace' : '${toLower(prefix)}-workspace'

@description('Specifies the service tier of the workspace: Free, Standalone, PerNode, Per-GB.')
@allowed([
  'Free'
  'Standalone'
  'PerNode'
  'PerGB2018'
])
param logAnalyticsSku string = 'PerNode'

@description('Specifies the workspace data retention in days. -1 means Unlimited retention for the Unlimited Sku. 730 days is the maximum allowed for all other Skus.')
param logAnalyticsRetentionInDays int = 60

@description('Specifies whether creating or not a jumpbox virtual machine in the AKS cluster virtual network.')
param vmEnabled bool = true

@description('Specifies the name of the virtual machine.')
param vmName string = 'TestVm'

@description('Specifies the size of the virtual machine.')
param vmSize string = 'Standard_DS3_v2'

@description('Specifies the image publisher of the disk image used to create the virtual machine.')
param imagePublisher string = 'Canonical'

@description('Specifies the offer of the platform image or marketplace image used to create the virtual machine.')
param imageOffer string = '0001-com-ubuntu-server-jammy'

@description('Specifies the Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version.')
param imageSku string = '22_04-lts-gen2'

@description('Specifies the type of authentication when accessing the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType string = 'sshPublicKey'

@description('Specifies the name of the administrator account of the virtual machine.')
param vmAdminUsername string

@description('Specifies the SSH Key or password for the virtual machine. SSH key is recommended.')
@secure()
param vmAdminPasswordOrKey string

@description('Specifies the storage account type for OS and data disk.')
@allowed([
  'Premium_LRS'
  'StandardSSD_LRS'
  'Standard_LRS'
  'UltraSSD_LRS'
])
param diskStorageAccountType string = 'Premium_LRS'

@description('Specifies the number of data disks of the virtual machine.')
@minValue(0)
@maxValue(64)
param numDataDisks int = 1

@description('Specifies the size in GB of the OS disk of the VM.')
param osDiskSize int = 50

@description('Specifies the size in GB of the OS disk of the virtual machine.')
param dataDiskSize int = 50

@description('Specifies the caching requirements for the data disks.')
param dataDiskCaching string = 'ReadWrite'

@description('Specifies the globally unique name for the storage account used to store the boot diagnostics logs of the virtual machine.')
param storageAccountName string = '${toLower(prefix)}${uniqueString(resourceGroup().id)}'

@description('Specifies whether to allow public network access for the storage account.')
@allowed([
  'Disabled'
  'Enabled'
])
param storageAccountPublicNetworkAccess string = 'Enabled'

@description('Specifies the access tier of the Azure Storage Account resource. The default value is Hot.')
param storageAccountAccessTier string = 'Hot'

@description('Specifies whether the Azure Storage Account resource allows public access to blobs.')
param storageAccountAllowBlobPublicAccess bool = true

@description('Specifies whether the Azure Storage Account resource allows shared key access.')
param storageAccountAllowSharedKeyAccess bool = true

@description('Specifies whether the Azure Storage Account resource allows cross-tenant replication.')
param storageAccountAllowCrossTenantReplication bool = false

@description('Specifies the minimum TLS version to be permitted on requests to the Azure Storage Account resource. The default value is TLS1_2.')
param storageAccountMinimumTlsVersion string = 'TLS1_2'

@description('The default action of allow or deny when no other rules match. Allowed values: Allow or Deny')
@allowed([
  'Allow'
  'Deny'
])
param storageAccountANetworkAclsDefaultAction string = 'Allow'

@description('Specifies whether the Azure Storage Account resource should only support HTTPS traffic.')
param storageAccountSupportsHttpsTrafficOnly bool = true

@description('Specifies whether to create containers.')
param storageAccountCreateContainers bool = false

@description('Specifies an array of containers to create.')
param storageAccountContainerNames array = []

@description('Specifies whether to create file shares.')
param storageAccountCreateFileShares bool = false

@description('Specifies an array of file shares to create.')
param storageAccountFileShareNames array = []

@description('Specifies the name of the private endpoint to the boot diagnostics storage account.')
param blobStorageAccountPrivateEndpointName string = letterCaseType == 'UpperCamelCase'
  ? 'StorageAccountPrivateEndpoint'
  : letterCaseType == 'CamelCase' ? 'storageAccountPrivateEndpoint' : 'storage-account-private-endpoint'

@description('Specifies the name of the private link to the Azure Container Registry.')
param acrPrivateEndpointName string = letterCaseType == 'UpperCamelCase'
  ? 'AcrPrivateEndpoint'
  : letterCaseType == 'CamelCase' ? 'acrPrivateEndpoint' : 'acr-private-endpoint'

@description('Name of your Azure Container Registry')
@minLength(5)
@maxLength(50)
param acrName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Acr'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Acr' : '${toLower(prefix)}-acr'

@description('Enable admin user that have push / pull permission to the registry.')
param acrAdminUserEnabled bool = false

@description('Tier of your Azure Container Registry.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param acrSku string = 'Premium'

@description('Specifies whether Azure Bastion should be created.')
param bastionHostEnabled bool = true

@description('Specifies the name of the Azure Bastion resource.')
param bastionHostName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Bastion'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Bastion' : '${toLower(prefix)}-bastion'

@description('Specifies whether creating an Application Gateway for Containers or not.')
param applicationGatewayForContainersEnabled bool = true

@description('Specifies the name of the Application Gateway for Containers.')
param applicationGatewayForContainersName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}ApplicationGatewayForContainers'
  : letterCaseType == 'CamelCase'
      ? '${toLower(prefix)}ApplicationGatewayForContainers'
      : '${toLower(prefix)}-application-gateway-for-containers'

@description('Specifies whether the Application Gateway for Containers is managed or bring your own (BYO).')
@allowed([
  'managed'
  'byo'
])
param applicationGatewayForContainersType string = 'managed'

@description('Specifies the name of the Azure NAT Gateway.')
param natGatewayName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}NatGateway'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}NatGateway' : '${toLower(prefix)}-nat-gateway'

@description('Specifies a list of availability zones denoting the zone in which Nat Gateway should be deployed.')
param natGatewayZones array = []

@description('Specifies the number of Public IPs to create for the Azure NAT Gateway.')
param natGatewayPublicIps int = 1

@description('Specifies the idle timeout in minutes for the Azure NAT Gateway.')
param natGatewayIdleTimeoutMins int = 30

@description('Specifies wether deploying the Azure Key Vault resource.')
param deployKeyVault bool = true

@description('Specifies the name of the private link to the Key Vault.')
param keyVaultPrivateEndpointName string = letterCaseType == 'UpperCamelCase'
  ? 'KeyVaultPrivateEndpoint'
  : letterCaseType == 'CamelCase' ? 'keyVaultPrivateEndpoint' : 'key-vault-private-endpoint'

@description('Specifies the name of the Key Vault resource.')
param keyVaultName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}KeyVault'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}KeyVault' : '${toLower(prefix)}-key-vault'

@description('Specifies whether to allow public network access for Key Vault.')
@allowed([
  'Disabled'
  'Enabled'
])
param keyVaultPublicNetworkAccess string = 'Disabled'

@description('Specifies the default action of allow or deny when no other rules match for the Azure Key Vault resource. Allowed values: Allow or Deny')
@allowed([
  'Allow'
  'Deny'
])
param keyVaultNetworkAclsDefaultAction string = 'Allow'

@description('Specifies whether the Azure Key Vault resource is enabled for deployments.')
param keyVaultEnabledForDeployment bool = true

@description('Specifies whether the Azure Key Vault resource is enabled for disk encryption.')
param keyVaultEnabledForDiskEncryption bool = true

@description('Specifies whether the Azure Key Vault resource is enabled for template deployment.')
param keyVaultEnabledForTemplateDeployment bool = true

@description('Specifies whether the soft delete is enabled for this Azure Key Vault resource.')
param keyVaultEnableSoftDelete bool = true

@description('Specifies whether purge protection is enabled for this Azure Key Vault resource.')
param keyVaultEnablePurgeProtection bool = true

@description('Specifies whether enable the RBAC authorization for the Azure Key Vault resource.')
param keyVaultEnableRbacAuthorization bool = true

@description('Specifies the soft delete retention in days.')
param keyVaultSoftDeleteRetentionInDays int = 7

@description('Specifies whether creating the Azure OpenAi resource or not.')
param openAiEnabled bool = false

@description('Specifies the name of the Azure OpenAI resource.')
param openAiName string = ''

@description('Specifies the location for all the Azure resources.')
param openAiLocation string = resourceGroup().location

@description('Specifies the resource model definition representing SKU.')
param openAiSku object = {
  name: 'S0'
}

@description('Specifies the identity of the OpenAI resource.')
param openAiIdentity object = {
  type: 'SystemAssigned'
}

@description('Specifies whether disable the local authentication via API key.')
param openAiDisableLocalAuth bool = false

@description('Specifies whether or not public endpoint access is allowed for this account..')
@allowed([
  'Enabled'
  'Disabled'
])
param openAiPublicNetworkAccess string = 'Enabled'

@description('Specifies the OpenAI deployments to create.')
param openAiDeployments array = []

@description('Specifies the name of the private link to the Azure OpenAI resource.')
param openAiPrivateEndpointName string = letterCaseType == 'UpperCamelCase'
  ? 'OpenAiPrivateEndpoint'
  : letterCaseType == 'CamelCase' ? 'OpenAiPrivateEndpoint' : 'openai-private-endpoint'

@description('Specifies the resource tags.')
param tags object = {
  IaC: 'Bicep'
}

@description('Specifies the resource tags.')
param clusterTags object

@description('Specifies the name of the Action Group.')
param actionGroupName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}ActionGroup'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}ActionGroup' : '${toLower(prefix)}-action-group'

@description('Specifies the short name of the action group. This will be used in SMS messages..')
param actionGroupShortName string = 'AksAlerts'

@description('Specifies whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications.')
param actionGroupEnabled bool = true

@description('Specifies the email address of the receiver.')
param actionGroupEmailAddress string

@description('Specifies whether to use common alert schema..')
param actionGroupUseCommonAlertSchema bool = false

@description('Specifies the country code of the SMS receiver.')
param actionGroupCountryCode string = '39'

@description('Specifies the phone number of the SMS receiver.')
param actionGroupPhoneNumber string = ''

@description('Specifies whether create or not Azure Monitor managed service for Prometheus and Azure Managed Grafana resources.')
param prometheusAndGrafanaEnabled bool = false

@description('Specifies a comma-separated list of additional Kubernetes label keys that will be used in the resource labels metric.')
param metricAnnotationsAllowList string = ''

@description('Specifies a comma-separated list of Kubernetes annotations keys that will be used in the resource labels metric.')
param metricLabelsAllowlist string = ''

@description('Specifies the name of the Azure Monitor managed service for Prometheus resource.')
param prometheusName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Prometheus'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Prometheus' : '${toLower(prefix)}-prometheus'

@description('Specifies whether or not public endpoint access is allowed for the Azure Monitor managed service for Prometheus resource.')
@allowed([
  'Enabled'
  'Disabled'
])
param prometheusPublicNetworkAccess string = 'Enabled'

@description('Specifies the name of the Azure Managed Grafana resource.')
param grafanaName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}Grafana'
  : letterCaseType == 'CamelCase' ? '${toLower(prefix)}Grafana' : '${toLower(prefix)}-grafana'

@description('Specifies the sku of the Azure Managed Grafana resource.')
param grafanaSkuName string = 'Standard'

@description('Specifies the api key setting of the Azure Managed Grafana resource.')
@allowed([
  'Disabled'
  'Enabled'
])
param grafanaApiKey string = 'Enabled'

@description('Specifies the scope for dns deterministic name hash calculation.')
@allowed([
  'TenantReuse'
])
param grafanaAutoGeneratedDomainNameLabelScope string = 'TenantReuse'

@description('Specifies whether the Azure Managed Grafana resource uses deterministic outbound IPs.')
@allowed([
  'Disabled'
  'Enabled'
])
param grafanaDeterministicOutboundIP string = 'Disabled'

@description('Specifies the the state for enable or disable traffic over the public interface for the the Azure Managed Grafana resource.')
@allowed([
  'Disabled'
  'Enabled'
])
param grafanaPublicNetworkAccess string = 'Enabled'

@description('The zone redundancy setting of the Azure Managed Grafana resource.')
@allowed([
  'Disabled'
  'Enabled'
])
param grafanaZoneRedundancy string = 'Disabled'

@description('Specifies the subdomain of the Kubernetes ingress object.')
param subdomain string = ''

@description('Specifies the domain of the Kubernetes ingress object.')
param domain string = ''

@description('Specifies the name of the gateway.')
param gatewayName string

@description('Specifies the namespace of the application.')
param namespace string = ''

@description('Specifies the service account of the application.')
param serviceAccountName string = ''

@description('Specifies the email address for the cert-manager cluster issuer.')
param email string = ''

@description('Specifies the name of the deployment script uri.')
param deploymentScripName string = 'DeploymentScript'

@description('Specifies the deployment script uri.')
param deploymentScriptUri string

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

@description('Specifies the name of the workload user-assigned managed identity.')
param certificateManagerManagedIdentityName string = letterCaseType == 'UpperCamelCase'
  ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}CertificateManagerManagedIdentity'
  : letterCaseType == 'CamelCase'
      ? '${toLower(prefix)}CertificateManagerManagedIdentity'
      : '${toLower(prefix)}-certificate-manager-managed-identity'

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

@description('Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources.')
param userObjectId string = ''

@description('Specifies the name of an existing public DNS zone.')
param dnsZoneName string

@description('Specifies the name of the resource group which contains the public DNS zone.')
param dnsZoneResourceGroupName string

//********************************************
// Variables
//********************************************

var aksTags = union(tags, clusterTags)

//********************************************
// Modules
//********************************************

module keyVault 'modules/keyVault.bicep' = if (deployKeyVault) {
  name: 'keyVault'
  params: {
    // properties
    name: keyVaultName
    location: location
    tags: tags
    publicNetworkAccess: keyVaultPublicNetworkAccess
    networkAclsDefaultAction: keyVaultNetworkAclsDefaultAction
    enabledForDeployment: keyVaultEnabledForDeployment
    enabledForDiskEncryption: keyVaultEnabledForDiskEncryption
    enabledForTemplateDeployment: keyVaultEnabledForTemplateDeployment
    enablePurgeProtection: keyVaultEnablePurgeProtection
    enableRbacAuthorization: keyVaultEnableRbacAuthorization
    enableSoftDelete: keyVaultEnableSoftDelete
    softDeleteRetentionInDays: keyVaultSoftDeleteRetentionInDays
    workspaceId: workspace.outputs.id

    // role assignments
    userObjectId: userObjectId
  }
}

module workspace 'modules/logAnalytics.bicep' = {
  name: 'workspace'
  params: {
    // properties
    name: logAnalyticsWorkspaceName
    location: location
    tags: tags
    sku: logAnalyticsSku
    retentionInDays: logAnalyticsRetentionInDays
  }
}

module containerRegistry './modules/containerRegistry.bicep' = {
  name: 'containerRegistry'
  params: {
    name: acrName
    sku: acrSku
    adminUserEnabled: acrAdminUserEnabled
    workspaceId: workspace.outputs.id
    location: location
    tags: tags
  }
}

module storageAccount './modules/storageAccount.bicep' = {
  name: 'storageAccount'
  params: {
    // properties
    name: storageAccountName
    location: location
    tags: tags
    publicNetworkAccess: storageAccountPublicNetworkAccess
    accessTier: storageAccountAccessTier
    allowBlobPublicAccess: storageAccountAllowBlobPublicAccess
    allowSharedKeyAccess: storageAccountAllowSharedKeyAccess
    allowCrossTenantReplication: storageAccountAllowCrossTenantReplication
    minimumTlsVersion: storageAccountMinimumTlsVersion
    networkAclsDefaultAction: storageAccountANetworkAclsDefaultAction
    supportsHttpsTrafficOnly: storageAccountSupportsHttpsTrafficOnly
    workspaceId: workspace.outputs.id
    createContainers: storageAccountCreateContainers
    containerNames: storageAccountContainerNames
    createFileShares: storageAccountCreateFileShares
    fileShareNames: storageAccountFileShareNames
    
    // role assignments
    userObjectId: userObjectId
  }
}

module network './modules/network.bicep' = {
  name: 'network'
  params: {
    podSubnetEnabled: aksClusterNetworkPluginMode != 'Overlay'
    enableVnetIntegration: enableVnetIntegration
    bastionHostEnabled: bastionHostEnabled
    virtualNetworkName: virtualNetworkName
    virtualNetworkAddressPrefixes: virtualNetworkAddressPrefixes
    systemAgentPoolSubnetName: systemAgentPoolSubnetName
    systemAgentPoolSubnetAddressPrefix: systemAgentPoolSubnetAddressPrefix
    userAgentPoolSubnetName: userAgentPoolSubnetName
    userAgentPoolSubnetAddressPrefix: userAgentPoolSubnetAddressPrefix
    windowsAgentPoolSubnetName: windowsAgentPoolSubnetName
    windowsAgentPoolSubnetAddressPrefix: windowsAgentPoolSubnetAddressPrefix
    windowsAgentPoolEnabled: windowsAgentPoolEnabled
    podSubnetName: podSubnetName
    podSubnetAddressPrefix: podSubnetAddressPrefix
    apiServerSubnetName: apiServerSubnetName
    apiServerSubnetAddressPrefix: apiServerSubnetAddressPrefix
    vmEnabled: vmEnabled
    vmSubnetName: vmSubnetName
    vmSubnetAddressPrefix: vmSubnetAddressPrefix
    vmSubnetNsgName: '${vmSubnetName}Nsg'
    bastionSubnetAddressPrefix: bastionSubnetAddressPrefix
    bastionSubnetNsgName: 'AzureBastionSubnetNsg'
    applicationGatewayForContainersEnabled: applicationGatewayForContainersEnabled
    applicationGatewayForContainersSubnetName: applicationGatewayForContainersSubnetName
    applicationGatewayForContainersSubnetAddressPrefix: applicationGatewayForContainersSubnetAddressPrefix
    bastionHostName: bastionHostName
    natGatewayName: natGatewayName
    natGatewayEnabled: aksClusterOutboundType == 'userAssignedNATGateway'
    natGatewayZones: natGatewayZones
    natGatewayPublicIps: natGatewayPublicIps
    natGatewayIdleTimeoutMins: natGatewayIdleTimeoutMins
    createAcrPrivateEndpoint: acrSku == 'Premium'
    storageAccountPrivateEndpointName: blobStorageAccountPrivateEndpointName
    storageAccountId: vmEnabled ? storageAccount.outputs.id : ''
    keyVaultPrivateEndpointName: keyVaultPrivateEndpointName
    keyVaultId: keyVault.outputs.id
    acrPrivateEndpointName: acrPrivateEndpointName
    acrId: containerRegistry.outputs.id
    openAiEnabled: openAiEnabled
    openAiPrivateEndpointName: openAiPrivateEndpointName
    openAiId: openAiEnabled ? openAi.outputs.id : ''
    workspaceId: workspace.outputs.id
    location: location
    tags: tags
  }
}

module jumpboxVirtualMachine './modules/virtualMachine.bicep' = if (vmEnabled) {
  name: 'jumpboxVirtualMachine'
  params: {
    vmName: vmName
    vmSize: vmSize
    vmSubnetId: network.outputs.vmSubnetId
    storageAccountName: vmEnabled ? storageAccount.outputs.name : ''
    imagePublisher: imagePublisher
    imageOffer: imageOffer
    imageSku: imageSku
    authenticationType: authenticationType
    vmAdminUsername: vmAdminUsername
    vmAdminPasswordOrKey: vmAdminPasswordOrKey
    diskStorageAccountType: diskStorageAccountType
    numDataDisks: numDataDisks
    osDiskSize: osDiskSize
    dataDiskSize: dataDiskSize
    dataDiskCaching: dataDiskCaching
    managedIdentityName: letterCaseType == 'UpperCamelCase'
      ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}AzureMonitorAgentManagedIdentity'
      : letterCaseType == 'CamelCase'
          ? '${toLower(prefix)}AzureMonitorAgentManagedIdentity'
          : '${toLower(prefix)}-azure-monitor-agent-managed-identity'
    location: location
    tags: tags
  }
}

module aksManagedIdentity './modules/aksManagedIdentity.bicep' = {
  name: 'aksManagedIdentity'
  params: {
    name: aksManagedIdentityName
    virtualNetworkName: network.outputs.virtualNetworkName
    location: location
    tags: tags
  }
}

module kubeletManageIdentity './modules/kubeletManagedIdentity.bicep' = {
  name: 'kubeletManageIdentity'
  params: {
    aksClusterName: aksCluster.outputs.name
    acrName: containerRegistry.outputs.name
  }
}

module applicationGatewayForContainers './modules/applicationGatewayForContainers.bicep' = if (applicationGatewayForContainersEnabled) {
  name: 'applicationGatewayForContainers'
  params: {
    name: applicationGatewayForContainersName
    type: applicationGatewayForContainersType
    workspaceId: workspace.outputs.id
    aksClusterName: aksCluster.outputs.name
    nodeResourceGroupName: aksCluster.outputs.nodeResourceGroup
    virtualNetworkName: network.outputs.virtualNetworkName
    subnetName: network.outputs.applicationGatewayForContainersSubnetName
    namespace: applicationGatewayForContainersAlbControllerNamespace
    serviceAccountName: applicationGatewayForContainersAlbControllerServiceAccountName
    location: location
    tags: tags
  }
}

module aksCluster './modules/aksCluster.bicep' = {
  name: 'aksCluster'
  params: {
    name: aksClusterName
    enableVnetIntegration: enableVnetIntegration
    virtualNetworkName: network.outputs.virtualNetworkName
    systemAgentPoolSubnetName: systemAgentPoolSubnetName
    userAgentPoolSubnetName: userAgentPoolSubnetName
    podSubnetName: podSubnetName
    apiServerSubnetName: apiServerSubnetName
    managedIdentityName: aksManagedIdentity.outputs.name
    dnsPrefix: aksClusterDnsPrefix
    networkDataplane: aksClusterNetworkDataplane
    networkMode: aksClusterNetworkMode
    networkPlugin: aksClusterNetworkPlugin
    networkPluginMode: aksClusterNetworkPluginMode
    networkPolicy: aksClusterNetworkPolicy
    webAppRoutingEnabled: aksClusterWebAppRoutingEnabled
    nginxDefaultIngressControllerType: aksClusterNginxDefaultIngressControllerType
    podCidr: aksClusterPodCidr
    serviceCidr: aksClusterServiceCidr
    dnsServiceIP: aksClusterDnsServiceIP
    loadBalancerSku: aksClusterLoadBalancerSku
    loadBalancerBackendPoolType: loadBalancerBackendPoolType
    advancedNetworking: advancedNetworking
    ipFamilies: aksClusterIpFamilies
    outboundType: aksClusterOutboundType
    skuTier: aksClusterSkuTier
    kubernetesVersion: aksClusterKubernetesVersion
    adminUsername: aksClusterAdminUsername
    sshPublicKey: aksClusterSshPublicKey
    aadProfileTenantId: aadProfileTenantId
    aadProfileAdminGroupObjectIDs: aadProfileAdminGroupObjectIDs
    aadProfileManaged: aadProfileManaged
    aadProfileEnableAzureRBAC: aadProfileEnableAzureRBAC
    nodeOSUpgradeChannel: aksClusterNodeOSUpgradeChannel
    upgradeChannel: aksClusterUpgradeChannel
    enablePrivateCluster: aksClusterEnablePrivateCluster
    privateDNSZone: aksPrivateDNSZone
    enablePrivateClusterPublicFQDN: aksEnablePrivateClusterPublicFQDN
    systemAgentPoolName: systemAgentPoolName
    systemAgentPoolVmSize: systemAgentPoolVmSize
    systemAgentPoolOsDiskSizeGB: systemAgentPoolOsDiskSizeGB
    systemAgentPoolOsDiskType: systemAgentPoolOsDiskType
    systemAgentPoolAgentCount: systemAgentPoolAgentCount
    systemAgentPoolOsSKU: systemAgentPoolOsSKU
    systemAgentPoolOsType: systemAgentPoolOsType
    systemAgentPoolMaxPods: systemAgentPoolMaxPods
    systemAgentPoolMaxCount: systemAgentPoolMaxCount
    systemAgentPoolMinCount: systemAgentPoolMinCount
    systemAgentPoolEnableAutoScaling: systemAgentPoolEnableAutoScaling
    systemAgentPoolScaleSetPriority: systemAgentPoolScaleSetPriority
    systemAgentPoolScaleSetEvictionPolicy: systemAgentPoolScaleSetEvictionPolicy
    systemAgentPoolNodeLabels: systemAgentPoolNodeLabels
    systemAgentPoolNodeTaints: systemAgentPoolNodeTaints
    systemAgentPoolType: systemAgentPoolType
    systemAgentPoolAvailabilityZones: systemAgentPoolAvailabilityZones
    systemAgentPoolKubeletDiskType: systemAgentPoolKubeletDiskType
    userAgentPoolName: userAgentPoolName
    userAgentPoolVmSize: userAgentPoolVmSize
    userAgentPoolOsDiskSizeGB: userAgentPoolOsDiskSizeGB
    userAgentPoolOsDiskType: userAgentPoolOsDiskType
    userAgentPoolAgentCount: userAgentPoolAgentCount
    userAgentPoolOsSKU: userAgentPoolOsSKU
    userAgentPoolOsType: userAgentPoolOsType
    userAgentPoolMaxPods: userAgentPoolMaxPods
    userAgentPoolMaxCount: userAgentPoolMaxCount
    userAgentPoolMinCount: userAgentPoolMinCount
    userAgentPoolEnableAutoScaling: userAgentPoolEnableAutoScaling
    userAgentPoolScaleSetPriority: userAgentPoolScaleSetPriority
    userAgentPoolScaleSetEvictionPolicy: userAgentPoolScaleSetEvictionPolicy
    userAgentPoolNodeLabels: userAgentPoolNodeLabels
    userAgentPoolNodeTaints: userAgentPoolNodeTaints
    userAgentPoolType: userAgentPoolType
    userAgentPoolAvailabilityZones: userAgentPoolAvailabilityZones
    userAgentPoolKubeletDiskType: userAgentPoolKubeletDiskType
    httpApplicationRoutingEnabled: httpApplicationRoutingEnabled
    istioServiceMeshEnabled: istioServiceMeshEnabled
    istioIngressGatewayEnabled: istioIngressGatewayEnabled
    istioIngressGatewayType: istioIngressGatewayType
    kedaEnabled: kedaEnabled
    daprEnabled: daprEnabled
    daprHaEnabled: daprHaEnabled
    fluxGitOpsEnabled: fluxGitOpsEnabled
    verticalPodAutoscalerEnabled: verticalPodAutoscalerEnabled
    aciConnectorLinuxEnabled: aciConnectorLinuxEnabled
    azurePolicyEnabled: azurePolicyEnabled
    azureKeyvaultSecretsProviderEnabled: azureKeyvaultSecretsProviderEnabled
    kubeDashboardEnabled: kubeDashboardEnabled
    autoScalerProfileScanInterval: autoScalerProfileScanInterval
    autoScalerProfileScaleDownDelayAfterAdd: autoScalerProfileScaleDownDelayAfterAdd
    autoScalerProfileScaleDownDelayAfterDelete: autoScalerProfileScaleDownDelayAfterDelete
    autoScalerProfileScaleDownDelayAfterFailure: autoScalerProfileScaleDownDelayAfterFailure
    autoScalerProfileScaleDownUnneededTime: autoScalerProfileScaleDownUnneededTime
    autoScalerProfileScaleDownUnreadyTime: autoScalerProfileScaleDownUnreadyTime
    autoScalerProfileUtilizationThreshold: autoScalerProfileUtilizationThreshold
    autoScalerProfileMaxGracefulTerminationSec: autoScalerProfileMaxGracefulTerminationSec
    blobCSIDriverEnabled: blobCSIDriverEnabled
    diskCSIDriverEnabled: diskCSIDriverEnabled
    fileCSIDriverEnabled: fileCSIDriverEnabled
    snapshotControllerEnabled: snapshotControllerEnabled
    defenderSecurityMonitoringEnabled: defenderSecurityMonitoringEnabled
    imageCleanerEnabled: imageCleanerEnabled
    imageCleanerIntervalHours: imageCleanerIntervalHours
    nodeRestrictionEnabled: nodeRestrictionEnabled
    workloadIdentityEnabled: workloadIdentityEnabled
    oidcIssuerProfileEnabled: oidcIssuerProfileEnabled
    prometheusAndGrafanaEnabled: true
    metricAnnotationsAllowList: metricAnnotationsAllowList
    metricLabelsAllowlist: metricLabelsAllowlist
    dnsZoneName: dnsZoneName
    dnsZoneResourceGroupName: dnsZoneResourceGroupName
    workspaceId: workspace.outputs.id
    userId: userId
    location: location
    tags: aksTags
  }
}

module windowsNodePool './modules/aksAgentPool.bicep' = if (windowsAgentPoolEnabled) {
  name: 'windowsNodePool'
  params: {
    name: windowsAgentPoolName
    mode: windowsAgentPoolMode
    aksClusterName: aksCluster.outputs.name
    count: windowsAgentPoolCount
    minCount: windowsAgentPoolMinCount
    maxCount: windowsAgentPoolMaxCount
    enableAutoScaling: windowsAgentPoolEnableAutoScaling
    maxPods: windowsAgentPoolMaxPods
    osDiskSizeGB: windowsAgentPoolOsDiskSizeGB
    osDiskType: windowsAgentPoolOsDiskType
    osSKU: windowsAgentPoolOsSKU
    osType: windowsAgentPoolOsType
    nodeTaints: windowsAgentPoolNodeTaints
    nodeLabels: windowsAgentPoolNodeLabels
    availabilityZones: windowsAgentPoolAvailabilityZones
    vmSize: windowsAgentPoolVmSize
    virtualNetworkName: network.outputs.virtualNetworkName
    vnetSubnetName: network.outputs.windowsAgentPoolSubnetName
    podSubnetName: network.outputs.podSubnetName
    enableNodePublicIP: windowsAgentPoolEnableNodePublicIP
  }
}

module workloadManagedIdentity './modules/workloadManagedIdentity.bicep' = if (workloadManagedIdentityEnabled) {
  name: 'workloadManagedIdentity'
  params: {
    name: workloadManagedIdentityName
    aksClusterName: aksCluster.outputs.name
    openAiName: openAiEnabled ? openAi.outputs.name : ''
    namespace: namespace
    serviceAccountName: serviceAccountName
    location: location
    tags: tags
  }
}

module certificateManagerManagedIdentity './modules/certificateManagerManagedIdentity.bicep' = if (deployCertificateManagerViaHelm) {
  name: 'certificateManagerManagedIdentity'
  params: {
    name: certificateManagerManagedIdentityName
    aksClusterName: aksCluster.outputs.name
    dnsZoneName: dnsZoneName
    dnsZoneResourceGroupName: dnsZoneResourceGroupName
    namespace: 'cert-manager'
    serviceAccountName: 'cert-manager'
    location: location
    tags: tags
  }
}

module actionGroup './modules/actionGroup.bicep' = if (actionGroupEnabled) {
  name: 'actionGroup'
  params: {
    name: actionGroupName
    enabled: actionGroupEnabled
    groupShortName: actionGroupShortName
    emailAddress: actionGroupEmailAddress
    useCommonAlertSchema: actionGroupUseCommonAlertSchema
    countryCode: actionGroupCountryCode
    phoneNumber: actionGroupPhoneNumber
    tags: tags
  }
}

module prometheus './modules/managedPrometheus.bicep' = if (prometheusAndGrafanaEnabled) {
  name: 'managedPrometheus'
  params: {
    name: prometheusName
    publicNetworkAccess: prometheusPublicNetworkAccess
    location: location
    tags: tags
    clusterName: aksCluster.outputs.name
    actionGroupId: actionGroupEnabled ? actionGroup.outputs.id : ''
  }
}

module grafana './modules/managedGrafana.bicep' = if (prometheusAndGrafanaEnabled) {
  name: 'managedGrafana'
  params: {
    name: grafanaName
    skuName: grafanaSkuName
    apiKey: grafanaApiKey
    autoGeneratedDomainNameLabelScope: grafanaAutoGeneratedDomainNameLabelScope
    deterministicOutboundIP: grafanaDeterministicOutboundIP
    publicNetworkAccess: grafanaPublicNetworkAccess
    zoneRedundancy: grafanaZoneRedundancy
    prometheusName: prometheus.outputs.name
    userId: userId
    location: location
    tags: tags
  }
}

module aksmetricalerts './modules/metricAlerts.bicep' = if (createMetricAlerts) {
  name: 'aksmetricalerts'
  scope: resourceGroup()
  params: {
    aksClusterName: aksCluster.outputs.name
    metricAlertsEnabled: metricAlertsEnabled
    evalFrequency: metricAlertsEvalFrequency
    windowSize: metricAlertsWindowsSize
    alertSeverity: 'Informational'
    actionGroupId: actionGroupEnabled ? actionGroup.outputs.id : ''
    tags: tags
  }
}

module deploymentScriptManagedIdentity './modules/deploymentScriptManagedIdentity.bicep' = {
  name: 'deploymentScriptManagedIdentity'
  params: {
    name: letterCaseType == 'UpperCamelCase'
      ? '${toUpper(first(prefix))}${toLower(substring(prefix, 1, length(prefix) - 1))}ScriptManagedIdentity'
      : letterCaseType == 'CamelCase'
          ? '${toLower(prefix)}ScriptManagedIdentity'
          : '${toLower(prefix)}-script-managed-identity'
    clusterName: aksCluster.outputs.name
    nodeResourceGroupName: aksCluster.outputs.nodeResourceGroup
    location: location
    tags: tags
  }
}

module deploymentScript './modules/deploymentScript.bicep' = {
  name: 'deploymentScript'
  params: {
    name: deploymentScripName
    azCliVersion: azCliVersion
    cleanupPreference: cleanupPreference  
    retentionInterval: retentionInterval
    deployNginxIngressControllerViaHelm: deployNginxIngressControllerViaHelm
    deployPrometheusAndGrafanaViaHelm: deployPrometheusAndGrafanaViaHelm
    deployCertificateManagerViaHelm: deployCertificateManagerViaHelm
    ingressClassNames: ingressClassNames
    clusterIssuerNames: clusterIssuerNames
    dnsZoneName: dnsZoneName
    dnsZoneResourceGroupName: dnsZoneResourceGroupName
    certificateManagerManagedIdentityClientId: certificateManagerManagedIdentity.outputs.clientId
    storageAccountName: storageAccount.outputs.name
    managedIdentityId: deploymentScriptManagedIdentity.outputs.id
    clusterName: aksCluster.outputs.name
    gatewayName: gatewayName
    namespace: namespace
    email: email
    primaryScriptUri: deploymentScriptUri
    resourceGroupName: resourceGroup().name
    nodeResourceGroupName: aksCluster.outputs.nodeResourceGroup
    tenantId: subscription().tenantId
    subscriptionId: subscription().subscriptionId
    workloadManagedIdentityClientId: workloadManagedIdentity.outputs.clientId
    applicationGatewayForContainersType: applicationGatewayForContainersType
    applicationGatewayForContainersEnabled: applicationGatewayForContainersEnabled ? 'true' : 'false'
    applicationGatewayForContainersManagedIdentityClientId: applicationGatewayForContainersEnabled
      ? applicationGatewayForContainers.outputs.clientId
      : ''
    applicationGatewayForContainersSubnetId: applicationGatewayForContainersEnabled
      ? network.outputs.applicationGatewayForContainersSubnetId
      : ''
    applicationGatewayForContainersHelmChartVersion: applicationGatewayForContainersHelmChartVersion
    workspaceId: workspace.outputs.id
    location: location
    tags: tags
  }
}

module openAi './modules/openAi.bicep' = if (openAiEnabled) {
  name: 'openAi'
  params: {
    name: openAiName
    sku: openAiSku
    identity: openAiIdentity
    customSubDomainName: openAiName
    disableLocalAuth: openAiDisableLocalAuth
    publicNetworkAccess: openAiPublicNetworkAccess
    deployments: openAiDeployments
    userObjectId: userObjectId
    workspaceId: workspace.outputs.id
    location: openAiLocation
    tags: tags
  }
}
