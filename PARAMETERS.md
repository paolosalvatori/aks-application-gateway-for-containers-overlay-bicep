# Parameters

This is the full list of the parameters.

```markdown
| Name | Type | Description |
|------|------|-------------|
| `prefix` | `string` | Specifies the name prefix for all the Azure resources. |
| `location` | `string` | Specifies the location for all the Azure resources. |
| `userId` | `string` | Specifies the object id of an Azure Active Directory user. In general, this the object id of the system administrator who deploys the Azure resources. |
| `letterCaseType` | `string` | Specifies whether name resources are in CamelCase, UpperCamelCase, or KebabCase. |
| `aksClusterName` | `string` | Specifies the name of the AKS cluster. |
| `createMetricAlerts` | `bool` | Specifies whether creating metric alerts or not. |
| `metricAlertsEnabled` | `bool` | Specifies whether metric alerts are enabled or disabled. |
| `metricAlertsEvalFrequency` | `string` | Specifies metric alerts eval frequency. |
| `metricAlertsWindowsSize` | `string` | Specifies metric alerts window size. |
| `aksManagedIdentityName` | `string` | Specifies the name of AKS user-assigned managed identity. |
| `aksClusterDnsPrefix` | `string` | Specifies the DNS prefix specified when creating the managed cluster. |
| `aksClusterNetworkPlugin` | `string` | Specifies the network plugin used for building Kubernetes network. |
| `aksClusterNetworkPluginMode` | `string` | Specifies the Network plugin mode used for building the Kubernetes network. |
| `aksClusterNetworkPolicy` | `string` | Specifies the network policy used for building Kubernetes network. |
| `aksClusterNetworkDataplane` | `string` | Specifies the network dataplane used in the Kubernetes cluster. |
| `aksClusterNetworkMode` | `string` | Specifies the network mode. This cannot be specified if networkPlugin is anything other than azure. |
| `aksClusterPodCidr` | `string` | Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used. |
| `aksClusterServiceCidr` | `string` | A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges. |
| `aksClusterDnsServiceIP` | `string` | Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr. |
| `aksClusterLoadBalancerSku` | `string` | Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools. |
| `loadBalancerBackendPoolType` | `string` | Specifies the type of the managed inbound Load Balancer BackendPool. |
| `advancedNetworking` | `object` | Specifies Advanced Networking profile for enabling observability on a cluster. |
| `aksClusterIpFamilies` | `array` | Specifies the IP families are used to determine single-stack or dual-stack clusters. For single-stack, the expected value is IPv4. For dual-stack, the expected values are IPv4 and IPv6. |
| `aksClusterOutboundType` | `string` | Specifies outbound (egress) routing method. |
| `aksClusterSkuTier` | `string` | Specifies the tier of a managed cluster SKU: Paid or Free |
| `aksClusterKubernetesVersion` | `string` | Specifies the version of Kubernetes specified when creating the managed cluster. |
| `aksClusterAdminUsername` | `string` | Specifies the administrator username of Linux virtual machines. |
| `aksClusterSshPublicKey` | `string` | Specifies the SSH RSA public key string for the Linux nodes. |
| `aadProfileTenantId` | `string` | Specifies the tenant id of the Azure Active Directory used by the AKS cluster for authentication. |
| `aadProfileAdminGroupObjectIDs` | `Array` | Specifies the AAD group object IDs that will have admin role of the cluster. |
| `aksClusterNodeOSUpgradeChannel` | `string` | Specifies the node OS upgrade channel. |
| `aksClusterUpgradeChannel` | `string` | Specifies the upgrade channel for auto upgrade. Allowed values include rapid, stable, patch, node-image, none. |
| `aksClusterEnablePrivateCluster` | `bool` | Specifies whether to create the cluster as a private cluster or not. |
| `aksClusterWebAppRoutingEnabled` | `bool` | Specifies whether the managed NGINX Ingress Controller application routing addon is enabled. |
| `aksClusterNginxDefaultIngressControllerType` | `string` | Specifies the ingress type for the default NginxIngressController custom resource. |
| `aksPrivateDNSZone` | `string` | Specifies the Private DNS Zone mode for private cluster. |
| `aksEnablePrivateClusterPublicFQDN` | `bool` | Specifies whether to create additional public FQDN for private cluster or not. |
| `aadProfileManaged` | `bool` | Specifies whether to enable managed AAD integration. |
| `aadProfileEnableAzureRBAC` | `bool` | Specifies whether to enable Azure RBAC for Kubernetes authorization. |
| `systemAgentPoolName` | `string` | Specifies the unique name of the system node pool profile in the context of the subscription and resource group. |
| `systemAgentPoolVmSize` | `string` | Specifies the vm size of nodes in the system node pool. |
| `systemAgentPoolOsDiskSizeGB` | `int` | Specifies the OS Disk Size in GB to be used to specify the disk size for every machine in the system agent pool. |
| `systemAgentPoolOsDiskType` | `string` | Specifies the OS disk type to be used for machines in a given agent pool. |
| `systemAgentPoolAgentCount` | `int` | Specifies the number of agents (VMs) to host docker containers in the system node pool. |
| `systemAgentPoolOsType` | `string` | Specifies the OS type for the vms in the system node pool. |
| `systemAgentPoolOsSKU` | `string` | Specifies the OS SKU used by the system agent pool. |
| `systemAgentPoolMaxPods` | `int` | Specifies the maximum number of pods that can run on a node in the system node pool. |
| `systemAgentPoolMaxCount` | `int` | Specifies the maximum number of nodes for auto-scaling for the system node pool. |
| `systemAgentPoolMinCount` | `int` | Specifies the minimum number of nodes for auto-scaling for the system node pool. |
| `systemAgentPoolEnableAutoScaling` | `bool` | Specifies whether to enable auto-scaling for the system node pool. |
| `systemAgentPoolScaleSetPriority` | `string` | Specifies the virtual machine scale set priority in the system node pool: Spot or Regular. |
| `systemAgentPoolScaleSetEvictionPolicy` | `string` | Specifies the ScaleSetEvictionPolicy to be used to specify eviction policy for spot virtual machine scale set. |
| `systemAgentPoolNodeLabels` | `object` | Specifies the Agent pool node labels to be persisted across all nodes in the system node pool. |
| `systemAgentPoolNodeTaints` | `Array` | Specifies the taints added to new nodes during node pool create and scale. |
| `systemAgentPoolKubeletDiskType` | `string` | Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage. |
| `systemAgentPoolType` | `string` | Specifies the type for the system node pool: VirtualMachineScaleSets or AvailabilitySet |
| `systemAgentPoolAvailabilityZones` | `array` | Specifies the availability zones for the agent nodes in the system node pool. |
| `userAgentPoolName` | `string` | Specifies the unique name of the user node pool profile in the context of the subscription and resource group. |
| `userAgentPoolVmSize` | `string` | Specifies the vm size of nodes in the user node pool. |
| `userAgentPoolOsDiskSizeGB` | `int` | Specifies the OS Disk Size in GB to be used to specify the disk size for every machine in the system agent pool. |
| `userAgentPoolOsDiskType` | `string` | Specifies the OS disk type to be used for machines in a given agent pool. |
| `userAgentPoolAgentCount` | `int` | Specifies the number of agents (VMs) to host docker containers in the user node pool. |
| `userAgentPoolOsType` | `string` | Specifies the OS type for the vms in the user node pool. |
| `userAgentPoolOsSKU` | `string` | Specifies the OS SKU used by the system agent pool. |
| `userAgentPoolMaxPods` | `int` | Specifies the maximum number of pods that can run on a node in the user node pool. |
| `userAgentPoolMaxCount` | `int` | Specifies the maximum number of nodes for auto-scaling for the user node pool. |
| `userAgentPoolMinCount` | `int` | Specifies the minimum number of nodes for auto-scaling for the user node pool. |
| `userAgentPoolEnableAutoScaling` | `bool` | Specifies whether to enable auto-scaling for the user node pool. |
| `userAgentPoolScaleSetPriority` | `string` | Specifies the virtual machine scale set priority in the user node pool: Spot or Regular. |
| `userAgentPoolScaleSetEvictionPolicy` | `string` | Specifies the ScaleSetEvictionPolicy to be used to specify eviction policy for spot virtual machine scale set. |
| `userAgentPoolNodeLabels` | `object` | Specifies the Agent pool node labels to be persisted across all nodes in the user node pool. |
| `userAgentPoolNodeTaints` | `Array` | Specifies the taints added to new nodes during node pool create and scale. |
| `userAgentPoolKubeletDiskType` | `string` | Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage. |
| `userAgentPoolType` | `string` | Specifies the type for the user node pool: VirtualMachineScaleSets or AvailabilitySet |
| `userAgentPoolAvailabilityZones` | `array` | Specifies the availability zones for the agent nodes in the user node pool. |
| `httpApplicationRoutingEnabled` | `bool` | Specifies whether the httpApplicationRouting add-on is enabled or not. |
| `istioServiceMeshEnabled` | `bool` | Specifies whether the Istio Service Mesh add-on is enabled or not. |
| `istioIngressGatewayEnabled` | `bool` | Specifies whether the Istio Ingress Gateway is enabled or not. |
| `istioIngressGatewayType` | `string` | Specifies the type of the Istio Ingress Gateway. |
| `kedaEnabled` | `bool` | Specifies whether the Kubernetes Event-Driven Autoscaler (KEDA) add-on is enabled or not. |
| `daprEnabled` | `bool` | Specifies whether the Dapr extension is enabled or not. |
| `daprHaEnabled` | `bool` | Enable high availability (HA) mode for the Dapr control plane |
| `fluxGitOpsEnabled` | `bool` | Specifies whether the Flux V2 extension is enabled or not. |
| `verticalPodAutoscalerEnabled` | `bool` | Specifies whether the Vertical Pod Autoscaler is enabled or not. |
| `aciConnectorLinuxEnabled` | `bool` | Specifies whether the aciConnectorLinux add-on is enabled or not. |
| `azurePolicyEnabled` | `bool` | Specifies whether the azurepolicy add-on is enabled or not. |
| `azureKeyvaultSecretsProviderEnabled` | `bool` | Specifies whether the Azure Key Vault Provider for Secrets Store CSI Driver addon is enabled or not. |
| `kubeDashboardEnabled` | `bool` | Specifies whether the kubeDashboard add-on is enabled or not. |
| `autoScalerProfileScanInterval` | `string` | Specifies the scan interval of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownDelayAfterAdd` | `string` | Specifies the scale down delay after add of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownDelayAfterDelete` | `string` | Specifies the scale down delay after delete of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownDelayAfterFailure` | `string` | Specifies scale down delay after failure of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownUnneededTime` | `string` | Specifies the scale down unneeded time of the auto-scaler of the AKS cluster. |
| `autoScalerProfileScaleDownUnreadyTime` | `string` | Specifies the scale down unready time of the auto-scaler of the AKS cluster. |
| `autoScalerProfileUtilizationThreshold` | `string` | Specifies the utilization threshold of the auto-scaler of the AKS cluster. |
| `autoScalerProfileMaxGracefulTerminationSec` | `string` | Specifies the max graceful termination time interval in seconds for the auto-scaler of the AKS cluster. |
| `enableVnetIntegration` | `bool` | Specifies whether to enable API server VNET integration for the cluster or not. |
| `windowsAgentPoolEnabled` | `bool` | Specifies whether to create a Windows agent pool. |
| `windowsAgentPoolName` | `string` | Specifies the name of the agent pool. |
| `windowsAgentPoolMode` | `string` | Specifies the mode of the agent pool. |
| `windowsAgentPoolAvailabilityZones` | `array` | Specifies the availability zones for the agent pool. |
| `windowsAgentPoolOsDiskType` | `string` | Specifies thr OS disk type of the agent pool. |
| `windowsAgentPoolVmSize` | `string` | Specifies the VM sku of the agent nodes. |
| `windowsAgentPoolOsDiskSizeGB` | `int` | Specifies the disk size in GB of the agent nodes. |
| `windowsAgentPoolCount` | `int` | Specifies the number of agents for the user agent pool |
| `windowsAgentPoolMinCount` | `int` | Specifies the minimum number of nodes for the user agent pool. |
| `windowsAgentPoolMaxCount` | `int` | Specifies the maximum number of nodes for the user agent pool. |
| `windowsAgentPoolMaxPods` | `int` | Specifies the maximum number of pods per node. |
| `windowsAgentPoolNodeTaints` | `Array` | Specifies the taints that should be applied to the agent pool. |
| `windowsAgentPoolNodeLabels` | `object` | Specifies the labels that should be applied to the agent pool. |
| `windowsAgentPoolOsType` | `string` | Specifies the OS Type for the agent pool. |
| `windowsAgentPoolOsSKU` | `string` | Specifies the OS SKU used by the system agent pool. |
| `windowsAgentPoolEnableNodePublicIP` | `bool` | Specifies whether assign a public IP per agent node. |
| `windowsAgentPoolEnableAutoScaling` | `bool` | Specifies whether to enable auto-scaling for the agent pool. |
| `virtualNetworkName` | `string` | Specifies the name of the virtual network. |
| `virtualNetworkAddressPrefixes` | `string` | Specifies the address prefixes of the virtual network. |
| `systemAgentPoolSubnetName` | `string` | Specifies the name of the subnet hosting the worker nodes of the default system agent pool of the AKS cluster. |
| `systemAgentPoolSubnetAddressPrefix` | `string` | Specifies the address prefix of the subnet hosting the worker nodes of the default system agent pool of the AKS cluster. |
| `userAgentPoolSubnetName` | `string` | Specifies the name of the subnet hosting the worker nodes of the user agent pool of the AKS cluster. |
| `userAgentPoolSubnetAddressPrefix` | `string` | Specifies the address prefix of the subnet hosting the worker nodes of the user agent pool of the AKS cluster. |
| `windowsAgentPoolSubnetName` | `string` | Specifies the name of the subnet which contains the pods running in the AKS cluster. |
| `windowsAgentPoolSubnetAddressPrefix` | `string` | Specifies the address prefix of the subnet which contains the pods running in the AKS cluster. |
| `blobCSIDriverEnabled` | `bool` | Specifies whether to enable the Azure Blob CSI Driver. |
| `diskCSIDriverEnabled` | `bool` | Specifies whether to enable the Azure Disk CSI Driver. |
| `fileCSIDriverEnabled` | `bool` | Specifies whether to enable the Azure File CSI Driver. |
| `snapshotControllerEnabled` | `bool` | Specifies whether to enable the Snapshot Controller. |
| `defenderSecurityMonitoringEnabled` | `bool` | Specifies whether to enable Defender threat detection. |
| `imageCleanerEnabled` | `bool` | Specifies whether to enable ImageCleaner on AKS cluster. |
| `imageCleanerIntervalHours` | `int` | Specifies ImageCleaner scanning interval in hours. |
| `nodeRestrictionEnabled` | `bool` | Specifies whether to enable Node Restriction. |
| `workloadIdentityEnabled` | `bool` | Specifies whether to enable Workload Identity. |
| `oidcIssuerProfileEnabled` | `bool` | Specifies whether the OIDC issuer is enabled. |
| `workloadManagedIdentityEnabled` | `bool` | Specifies whether the workload managed identity is enabled. |
| `workloadManagedIdentityName` | `string` | Specifies the name of the workload user-assigned managed identity. |
| `podSubnetName` | `string` | Specifies the name of the subnet hosting the pods running in the AKS cluster. |
| `podSubnetAddressPrefix` | `string` | Specifies the address prefix of the subnet hosting the pods running in the AKS cluster. |
| `apiServerSubnetName` | `string` | Specifies the name of the subnet delegated to the API server when configuring the AKS cluster to use API server VNET integration. |
| `apiServerSubnetAddressPrefix` | `string` | Specifies the address prefix of the subnet delegated to the API server when configuring the AKS cluster to use API server VNET integration. |
| `vmSubnetName` | `string` | Specifies the name of the subnet which contains the virtual machine. |
| `vmSubnetAddressPrefix` | `string` | Specifies the address prefix of the subnet which contains the virtual machine. |
| `bastionSubnetAddressPrefix` | `string` | Specifies the Bastion subnet IP prefix. This prefix must be within vnet IP prefix address space. |
| `applicationGatewayForContainersSubnetName` | `string` | Specifies the name of the subnet which contains the Application Gateway for Containers. |
| `applicationGatewayForContainersSubnetAddressPrefix` | `string` | Specifies the address prefix of the subnet which contains the Application Gateway for Containers. |
| `applicationGatewayForContainersAlbControllerNamespace` | `string` | Specifies the namespace for the Application Load Balancer Controller of the Application Gateway for Containers. |
| `applicationGatewayForContainersAlbControllerServiceAccountName` | `string` | Specifies the name of the service account for the Application Load Balancer Controller of the Application Gateway for Containers. |
| `applicationGatewayForContainersHelmChartVersion` | `string` | Specifies the helm chart version of the Application Gateway for Containers. |
| `logAnalyticsWorkspaceName` | `string` | Specifies the name of the Log Analytics Workspace. |
| `logAnalyticsSku` | `string` | Specifies the service tier of the workspace. |
| `logAnalyticsRetentionInDays` | `int` | Specifies the workspace data retention in days. |
| `vmEnabled` | `bool` | Specifies whether creating or not a jumpbox virtual machine in the AKS cluster virtual network. |
| `vmName` | `string` | Specifies the name of the virtual machine. |
| `vmSize` | `string` | Specifies the size of the virtual machine. |
| `imagePublisher` | `string` | Specifies the image publisher of the disk image used to create the virtual machine. |
| `imageOffer` | `string` | Specifies the offer of the platform image or marketplace image used to create the virtual machine. |
| `imageSku` | `string` | Specifies the Ubuntu version for the VM. |
| `authenticationType` | `string` | Specifies the type of authentication when accessing the Virtual Machine. |
| `vmAdminUsername` | `string` | Specifies the name of the administrator account of the virtual machine. |
| `vmAdminPasswordOrKey` | `string` | Specifies the SSH Key or password for the virtual machine. |
| `diskStorageAccountType` | `string` | Specifies the storage account type for OS and data disk. |
| `numDataDisks` | `int` | Specifies the number of data disks of the virtual machine. |
| `osDiskSize` | `int` | Specifies the size in GB of the OS disk of the VM. |
| `dataDiskSize` | `int` | Specifies the size in GB of the OS disk of the virtual machine. |
| `storageAccountName` | `string` | Specifies the globally unique name for the storage account used to store the boot diagnostics logs of the virtual machine. |
| `storageAccountPublicNetworkAccess` | `string` | Specifies whether to allow public network access for the storage account. |
| `storageAccountAccessTier` | `string` | Specifies the access tier of the Azure Storage Account resource. |
| `storageAccountAllowBlobPublicAccess` | `bool` | Specifies whether the Azure Storage Account resource allows public access to blobs. |
| `storageAccountAllowSharedKeyAccess` | `bool` | Specifies whether the Azure Storage Account resource allows shared key access. |
| `storageAccountAllowCrossTenantReplication` | `bool` | Specifies whether the Azure Storage Account resource allows cross-tenant replication. |
| `storageAccountMinimumTlsVersion` | `string` | Specifies the minimum TLS version to be permitted on requests to the Azure Storage Account resource. |
| `storageAccountANetworkAclsDefaultAction` | `string` | The default action of allow or deny when no other rules match. |
| `storageAccountSupportsHttpsTrafficOnly` | `bool` | Specifies whether the Azure Storage Account resource should only support HTTPS traffic. |
| `storageAccountCreateContainers` | `bool` | Specifies whether to create containers. |
| `storageAccountContainerNames` | `Array` | Specifies an array of containers to create. |
| `storageAccountCreateFileShares` | `bool` | Specifies whether to create file shares. |
| `storageAccountFileShareNames` | `Array` | Specifies an array of file shares to create. |
| `blobStorageAccountPrivateEndpointName` | `string` | Specifies the name of the private endpoint to the boot diagnostics storage account. |
| `acrPrivateEndpointName` | `string` | Specifies the name of the private link to the Azure Container Registry. |
| `acrName` | `string` | Name of your Azure Container Registry. |
| `acrAdminUserEnabled` | `bool` | Enable admin user that have push / pull permission to the registry. |
| `acrSku` | `string` | Tier of your Azure Container Registry. |
| `bastionHostEnabled` | `bool` | Specifies whether Azure Bastion should be created. |
| `bastionHostName` | `string` | Specifies the name of the Azure Bastion resource. |
| `applicationGatewayForContainersEnabled` | `bool` | Specifies whether creating an Application Gateway for Containers or not. |
| `applicationGatewayForContainersName` | `string` | Specifies the name of the Application Gateway for Containers. |
| `applicationGatewayForContainersType` | `string` | Specifies whether the Application Gateway for Containers is managed or bring your own (BYO). |
| `natGatewayName` | `string` | Specifies the name of the Azure NAT Gateway. |
| `natGatewayZones` | `array` | Specifies a list of availability zones denoting the zone in which Nat Gateway should be deployed. |
| `natGatewayPublicIps` | `int` | Specifies the number of Public IPs to create for the Azure NAT Gateway. |
| `natGatewayIdleTimeoutMins` | `int` | Specifies the idle timeout in minutes for the Azure NAT Gateway. |
| `deployKeyVault` | `bool` | Specifies whether to deploy the Azure Key Vault resource. |
| `keyVaultPrivateEndpointName` | `string` | Specifies the name of the private link to the Key Vault. |
| `keyVaultName` | `string` | Specifies the name of the Key Vault resource. |
| `keyVaultPublicNetworkAccess` | `string` | Specifies whether to allow public network access for Key Vault. |
| `keyVaultNetworkAclsDefaultAction` | `string` | Specifies the default action of allow or deny when no other rules match for the Azure Key Vault resource. |
| `keyVaultEnabledForDeployment` | `bool` | Specifies whether the Azure Key Vault resource is enabled for deployments. |
| `keyVaultEnabledForDiskEncryption` | `bool` | Specifies whether the Azure Key Vault resource is enabled for disk encryption. |
| `keyVaultEnabledForTemplateDeployment` | `bool` | Specifies whether the Azure Key Vault resource is enabled for template deployment. |
| `keyVaultEnableSoftDelete` | `bool` | Specifies whether the soft delete is enabled for this Azure Key Vault resource. |
| `keyVaultEnablePurgeProtection` | `bool` | Specifies whether purge protection is enabled for this Azure Key Vault resource. |
| `keyVaultEnableRbacAuthorization` | `bool` | Specifies whether enable the RBAC authorization for the Azure Key Vault resource. |
| `keyVaultSoftDeleteRetentionInDays` | `int` | Specifies the soft delete retention in days. |
| `openAiEnabled` | `bool` | Specifies whether creating the Azure OpenAi resource or not. |
| `openAiName` | `string` | Specifies the name of the Azure OpenAI resource. |
| `openAiLocation` | `string` | Specifies the location for all the Azure resources. |
| `openAiSku` | `object` | Specifies the resource model definition representing SKU. |
| `openAiIdentity` | `object` | Specifies the identity of the OpenAI resource. |
| `openAiDisableLocalAuth` | `bool` | Specifies whether disable the local authentication via API key. |
| `openAiPublicNetworkAccess` | `string` | Specifies whether or not public endpoint access is allowed for this account. |
| `openAiDeployments` | `array` | Specifies the OpenAI deployments to create. |
| `openAiPrivateEndpointName` | `string` | Specifies the name of the private link to the Azure OpenAI resource. |
| `tags` | `object` | Specifies the resource tags. |
| `clusterTags` | `object` | Specifies the resource tags. |
| `actionGroupName` | `string` | Specifies the name of the Action Group. |
| `actionGroupShortName` | `string` | Specifies the short name of the action group. This will be used in SMS messages. |
| `actionGroupEnabled` | `bool` | Specifies whether this action group is enabled. |
| `actionGroupEmailAddress` | `string` | Specifies the email address of the receiver. |
| `actionGroupUseCommonAlertSchema` | `bool` | Specifies whether to use common alert schema. |
| `actionGroupCountryCode` | `string` | Specifies the country code of the SMS receiver. |
| `actionGroupPhoneNumber` | `string` | Specifies the phone number of the SMS receiver. |
| `prometheusAndGrafanaEnabled` | `bool` | Specifies whether to create or not Azure Monitor managed service for Prometheus and Azure Managed Grafana resources. |
| `metricAnnotationsAllowList` | `string` | Specifies a comma-separated list of additional Kubernetes label keys that will be used in the resource labels metric. |
| `metricLabelsAllowlist` | `string` | Specifies a comma-separated list of Kubernetes annotations keys that will be used in the resource labels metric. |
| `prometheusName` | `string` | Specifies the name of the Azure Monitor managed service for Prometheus resource. |
| `prometheusPublicNetworkAccess` | `string` | Specifies whether or not public endpoint access is allowed for the Azure Monitor managed service for Prometheus resource. |
| `grafanaName` | `string` | Specifies the name of the Azure Managed Grafana resource. |
| `grafanaSkuName` | `string` | Specifies the sku of the Azure Managed Grafana resource. |
| `grafanaApiKey` | `string` | Specifies the api key setting of the Azure Managed Grafana resource. |
| `grafanaAutoGeneratedDomainNameLabelScope` | `string` | Specifies the scope for dns deterministic name hash calculation. |
| `grafanaDeterministicOutboundIP` | `string` | Specifies whether the Azure Managed Grafana resource uses deterministic outbound IPs. |
| `grafanaPublicNetworkAccess` | `string` | Specifies the the state for enable or disable traffic over the public interface for the the Azure Managed Grafana resource. |
| `grafanaZoneRedundancy` | `string` | The zone redundancy setting of the Azure Managed Grafana resource. |
| `subdomain` | `string` | Specifies the subdomain of the Kubernetes ingress object. |
| `domain` | `string` | Specifies the domain of the Kubernetes ingress object. |
| `gatewayName` | `string` | Specifies the name of the gateway. |
| `namespace` | `string` | Specifies the namespace of the application. |
| `serviceAccountName` | `string` | Specifies the service account of the application. |
| `email` | `string` | Specifies the email address for the cert-manager cluster issuer. |
| `deploymentScripName` | `string` | Specifies the name of the deployment script uri. |
| `deploymentScriptUri` | `string` | Specifies the deployment script uri. |
| `azCliVersion` | `string` | Specifies the Azure CLI module version. |
| `cleanupPreference` | `string` | Specifies the clean up preference when the script execution gets in a terminal state. |
| `retentionInterval` | `string` | Specifies the interval for which the service retains the script resource after it reaches a terminal state. |
| `deployPrometheusAndGrafanaViaHelm` | `bool` | Specifies whether to deploy Prometheus and Grafana to the AKS cluster using a Helm chart. |
| `deployCertificateManagerViaHelm` | `bool` | Specifies whether to whether to deploy the Certificate Manager to the AKS cluster using a Helm chart. |
| `certificateManagerManagedIdentityName` | `string` | Specifies the name of the workload user-assigned managed identity. |
| `ingressClassNames` | `array` | Specifies the list of ingress classes for which a cert-manager cluster issuer should be created. |
| `clusterIssuerNames` | `array` | Specifies the list of the names for the cert-manager cluster issuers. |
| `deployNginxIngressControllerViaHelm` | `string` | Specifies whether and how to deploy the NGINX Ingress Controller to the AKS cluster using a Helm chart. |
| `userObjectId` | `string` | Specifies the object id of a Microsoft Entra ID user. |
| `dnsZoneName` | `string` | Specifies the name of an existing public DNS zone. |
| `dnsZoneResourceGroupName` | `string` | Specifies the name of the resource group which contains the public DNS zone. |
```