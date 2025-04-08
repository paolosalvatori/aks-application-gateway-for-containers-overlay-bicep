#!/bin/bash

# Variables
source ./00-variables.sh

# Curling this FQDN should return responses from the backend as configured in the HTTPRoute
headers=$(curl https://$hostname/response-headers -H "accept: application/json" -s | jq -r .headers)

# Print the IP address
echo "Response Headers"
echo $headers | jq -r

