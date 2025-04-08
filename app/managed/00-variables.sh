# Certificate Manager
cmNamespace="cert-manager"
cmRepoName="jetstack"
cmRepoUrl="https://charts.jetstack.io"
cmChartName="cert-manager"
cmReleaseName="cert-manager"

# Application Load Balancer 
applicationLoadBalancerName="alb"
applicationLoadBalancerNamespace="alb-infra"

# Demo
namespace="httpbin"
gatewayName="httpbin-gateway"
issuerName="letsencrypt"
httpRouteName="httpbin-route"

# Ingress and DNS
dnsZoneName="babosbird.com"
dnsZoneResourceGroupName="DnsResourceGroup"
subdomain="miki"
hostname="$subdomain.$dnsZoneName"
