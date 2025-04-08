# Install git and tar
apk add --no-cache --quiet git tar

# Install kubectl
az aks install-cli --only-show-errors

# Get AKS credentials
az aks get-credentials \
  --admin \
  --name $clusterName \
  --resource-group $resourceGroupName \
  --subscription $subscriptionId \
  --only-show-errors

# Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh &>/dev/null

# initialize variables
applicationGatewayForContainersName=''
diagnosticSettingName="DefaultDiagnosticSettings"

# Install openssl
apk add --no-cache --quiet openssl

# Add Helm repos
if [[ $deployPrometheusAndGrafanaViaHelm == 'true' ]]; then
  echo "Adding Prometheus Helm repository..."
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
fi

if [[ $deployCertificateManagerViaHelm == 'true' ]]; then
  echo "Adding cert-manager Helm repository..."
  helm repo add jetstack https://charts.jetstack.io
fi

if [[ $deployNginxIngressControllerViaHelm != 'None' ]]; then
  echo "Adding NGINX ingress controller Helm repository..."
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
fi

# Update Helm repos
echo "Updating Helm repositories..."
helm repo update

# Install Prometheus
if [[ $deployPrometheusAndGrafanaViaHelm == 'true' ]]; then
  echo "Installing Prometheus and Grafana..."
  helm upgrade prometheus prometheus-community/kube-prometheus-stack \
    --install \
    --create-namespace \
    --namespace prometheus \
    --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
    --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false
fi

# Install certificate manager
if [[ $deployCertificateManagerViaHelm == 'true' ]]; then
  echo "Installing Certificate Manager..."

  cat <<EOF > values.yaml
# values.yaml
podLabels:
  azure.workload.identity/use: "true"
serviceAccount:
  labels:
    azure.workload.identity/use: "true"
EOF

  helm upgrade cert-manager jetstack/cert-manager \
    --install \
    --create-namespace \
    --namespace cert-manager \
    --set crds.enabled=true \
    --set config.enableGatewayAPI=true \
    --set prometheus.enabled=true \
    --set nodeSelector."kubernetes\.io/os"=linux \
    --values values.yaml

  # Remove brackets and quotes, then split into an array
  if [[ $ingressClassNames == \[*\] ]]; then
    # Handle JSON-like array
    ingressClassNames=${ingressClassNames:1:-1} # Remove the square brackets
  fi

  # Create arrays from the comma-separated string
  IFS=',' read -ra ingressClassArray <<<"$ingressClassNames"   # Split the string into an array

   # Remove brackets and quotes, then split into an array
  if [[ $clusterIssuerNames == \[*\] ]]; then
    # Handle JSON-like array
    clusterIssuerNames=${clusterIssuerNames:1:-1} # Remove the square brackets
  fi

  # Create arrays from the comma-separated string
  IFS=',' read -ra clusterIssuerArray <<<"$clusterIssuerNames" # Split the string into an array


  echo "Ingress Class Names: ${ingressClassArray[@]}"
  echo "Cluster Issuer Names: ${clusterIssuerArray[@]}"

  # Check if the two arrays have the same length and are not empty
  # Check if the two arrays have the same length and are not empty
  if [[ ${#ingressClassArray[@]} > 0 && ${#ingressClassArray[@]} == ${#clusterIssuerArray[@]} ]]; then
    for i in ${!ingressClassArray[@]}; do
      echo "Creating cluster issuer ${clusterIssuerArray[$i]} for the ${ingressClassArray[$i]} ingress class..."
      
      # Create cluster issuer
      cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ${clusterIssuerArray[$i]}
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: $email
    privateKeySecretRef:
      name: ${clusterIssuerArray[$i]}
    solvers:
    - http01:
        ingress:
          class: ${ingressClassArray[$i]}
          podTemplate:
            spec:
              nodeSelector:
                "kubernetes.io/os": linux
EOF
    done
  fi

  if [[ -n $gatewayName && -n $namespace ]]; then
    echo "Creating cluster issuer for the ${gatewayName[$i]} gateway..."
    cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-gateway
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: $email
    privateKeySecretRef:
      name: letsencrypt-gateway
    solvers:
      - http01:
          gatewayHTTPRoute:
            parentRefs:
              - name: $gatewayName
                namespace: $namespace
                kind: Gateway
EOF
  fi

  if [[ -n $dnsZoneName && -n $dnsZoneResourceGroupName && -n certificateManagerManagedIdentityClientId ]]; then
        # Create DNS01 challenge issuer
        echo "Creating DNS01 challenge issuer for the ${ingressClassArray[$i]} ingress class..."
        cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-dns
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: $email
    privateKeySecretRef:
      name: letsencrypt-dns
    solvers:
    - dns01:
        azureDNS:
          resourceGroupName: $dnsZoneResourceGroupName
          subscriptionID: $subscriptionId
          hostedZoneName: $dnsZoneName
          environment: AzurePublicCloud
          managedIdentity:
            clientID: $certificateManagerManagedIdentityClientId

EOF
  fi
fi

if [[ $deployNginxIngressControllerViaHelm == 'External' ]]; then
  # Install NGINX ingress controller using the internal load balancer
  echo "Installing NGINX ingress controller using the public load balancer..."
  helm upgrade nginx-ingress ingress-nginx/ingress-nginx \
    --install \
    --create-namespace \
    --namespace ingress-basic \
    --set controller.replicaCount=3 \
    --set controller.nodeSelector."kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
    --set controller.metrics.enabled=true \
    --set controller.metrics.serviceMonitor.enabled=true \
    --set controller.metrics.serviceMonitor.additionalLabels.release="prometheus" \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz
fi

if [[ $deployNginxIngressControllerViaHelm == 'Internal' ]]; then
  # Install NGINX ingress controller using the internal load balancer
  echo "Installing NGINX ingress controller using the internal load balancer..."
  helm install nginx-ingress ingress-nginx/ingress-nginx \
    --create-namespace \
    --namespace ingress-basic \
    --set controller.replicaCount=3 \
    --set controller.nodeSelector."kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
    --set controller.metrics.enabled=true \
    --set controller.metrics.serviceMonitor.enabled=true \
    --set controller.metrics.serviceMonitor.additionalLabels.release="prometheus" \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal"=true
fi

if [[ -n "$namespace" &&
  -n "$serviceAccountName" ]]; then
  # Create workload namespace
  result=$(kubectl get namespace -o 'jsonpath={.items[?(@.metadata.name=="'$namespace'")].metadata.name'})

  if [[ -n $result ]]; then
    echo "$namespace namespace already exists in the cluster"
  else
    echo "$namespace namespace does not exist in the cluster"
    echo "Creating $namespace namespace in the cluster..."
    kubectl create namespace $namespace
  fi

  # Create service account
  echo "Creating $serviceAccountName service account..."
  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    azure.workload.identity/client-id: $workloadManagedIdentityClientId
    azure.workload.identity/tenant-id: $tenantId
  labels:
    azure.workload.identity/use: "true"
  name: $serviceAccountName
  namespace: $namespace
EOF
fi

if [[ "$applicationGatewayForContainersEnabled" == "true" &&
  -n "$applicationGatewayForContainersManagedIdentityClientId" &&
  -n "$applicationGatewayForContainersSubnetId" ]]; then

  # Install the Application Load Balancer
  echo "Installing Application Load Balancer Controller in $applicationGatewayForContainersNamespace namespace using $applicationGatewayForContainersManagedIdentityClientId managed identity..."
  helm upgrade alb-controller oci://mcr.microsoft.com/application-lb/charts/alb-controller \
    --install \
    --create-namespace \
    --namespace $applicationGatewayForContainersNamespace \
    --version $applicationGatewayForContainersHelmChartVersion \
    --set albController.namespace=$applicationGatewayForContainersNamespace \
    --set albController.podIdentity.clientID=$applicationGatewayForContainersManagedIdentityClientId

  if [[ $? == 0 ]]; then
    echo "Application Load Balancer Controller successfully installed"
  else
    echo "Failed to install Application Load Balancer Controller"
    exit -1
  fi

  if [[ "$applicationGatewayForContainersType" == "managed" ]]; then
    # Create alb-infra namespace
    albInfraNamespace='alb-infra'
    result=$(kubectl get namespace -o 'jsonpath={.items[?(@.metadata.name=="'$albInfraNamespace'")].metadata.name'})

    if [[ -n $result ]]; then
      echo "$albInfraNamespace namespace already exists in the cluster"
    else
      echo "$albInfraNamespace namespace does not exist in the cluster"
      echo "Creating $albInfraNamespace namespace in the cluster..."
      kubectl create namespace $albInfraNamespace
    fi

    # Define the ApplicationLoadBalancer resource, specifying the subnet ID the Application Gateway for Containers association resource should deploy into.
    # The association establishes connectivity from Application Gateway for Containers to the defined subnet (and connected networks where applicable) to
    # be able to proxy traffic to a defined backend.
    echo "Creating ApplicationLoadBalancer resource..."
    kubectl apply -f - <<EOF
apiVersion: alb.networking.azure.io/v1
kind: ApplicationLoadBalancer
metadata:
  name: alb
  namespace: $albInfraNamespace
spec:
  associations:
  - $applicationGatewayForContainersSubnetId
EOF
    if [[ -n $nodeResourceGroupName ]]; then
      echo -n "Retrieving the resource id of the Application Gateway for Containers..."
      counter=1
      while [ $counter -le 20 ]; do
        # Retrieve the resource id of the managed Application Gateway for Containers resource
        applicationGatewayForContainersId=$(az resource list \
          --resource-type "Microsoft.ServiceNetworking/TrafficControllers" \
          --resource-group $nodeResourceGroupName \
          --query [0].id \
          --output tsv)
        if [[ -n $applicationGatewayForContainersId ]]; then
          echo
          break
        else
          echo -n '.'
          counter=$((counter + 1))
          sleep 1
        fi
      done

      if [[ -n $applicationGatewayForContainersId ]]; then
        applicationGatewayForContainersName=$(basename $applicationGatewayForContainersId)
        echo "[$applicationGatewayForContainersId] resource id of the [$applicationGatewayForContainersName] Application Gateway for Containers successfully retrieved"
      else
        echo "Failed to retrieve the resource id of the Application Gateway for Containers"
        exit -1
      fi

      # Check if the diagnostic setting already exists for the Application Gateway for Containers
      echo "Checking if the [$diagnosticSettingName] diagnostic setting for the [$applicationGatewayForContainersName] Application Gateway for Containers actually exists..."
      result=$(az monitor diagnostic-settings show \
        --name $diagnosticSettingName \
        --resource $applicationGatewayForContainersId \
        --query name \
        --output tsv 2>/dev/null)

      if [[ -z $result ]]; then
        echo "[$diagnosticSettingName] diagnostic setting for the [$applicationGatewayForContainersName] Application Gateway for Containers does not exist"
        echo "Creating [$diagnosticSettingName] diagnostic setting for the [$applicationGatewayForContainersName] Application Gateway for Containers..."

        # Create the diagnostic setting for the Application Gateway for Containers
        az monitor diagnostic-settings create \
          --name $diagnosticSettingName \
          --resource $applicationGatewayForContainersId \
          --logs '[{"categoryGroup": "allLogs", "enabled": true}]' \
          --metrics '[{"category": "AllMetrics", "enabled": true}]' \
          --workspace $workspaceId \
          --only-show-errors 1>/dev/null

        if [[ $? == 0 ]]; then
          echo "[$diagnosticSettingName] diagnostic setting for the [$applicationGatewayForContainersName] Application Gateway for Containers successfully created"
        else
          echo "Failed to create [$diagnosticSettingName] diagnostic setting for the [$applicationGatewayForContainersName] Application Gateway for Containers"
          exit -1
        fi
      else
        echo "[$diagnosticSettingName] diagnostic setting for the [$applicationGatewayForContainersName] Application Gateway for Containers already exists"
      fi
    fi
  fi
fi

# Create output as JSON file
echo '{}' |
  jq --arg x $applicationGatewayForContainersName '.applicationGatewayForContainersName=$x' |
  jq --arg x $namespace '.namespace=$x' |
  jq --arg x $serviceAccountName '.serviceAccountName=$x' |
  jq --arg x 'prometheus' '.prometheus=$x' |
  jq --arg x 'cert-manager' '.certManager=$x' |
  jq --arg x 'ingress-basic' '.nginxIngressController=$x' >$AZ_SCRIPTS_OUTPUT_PATH
