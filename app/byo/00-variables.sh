# Certificate Manager
cmNamespace="cert-manager"
cmRepoName="jetstack"
cmRepoUrl="https://charts.jetstack.io"
cmChartName="cert-manager"
cmReleaseName="cert-manager"

# Application Gateway for Containers
applicationGatewayForContainersName='ShogunApplicationGatewayForContainers'
resourceGroupName='ShogunRG'
frontendName="DefaultFrontend"

# Demo
namespace="httpbin"
gatewayName="httpbin-gateway"
issuerName="letsencrypt"
httpRouteName="httpbin-route"

# Ingress and DNS
dnsZoneName="babosbird.com"
dnsZoneResourceGroupName="DnsResourceGroup"
subdomain="shogunagc"
hostname="$subdomain.$dnsZoneName"
