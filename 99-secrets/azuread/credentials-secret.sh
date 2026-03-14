#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Creates the Azure credentials secret for Crossplane
#
# Usage:
#   AZURE_TENANT_ID=xxx \
#   AZURE_CLIENT_ID=yyy \
#   AZURE_CLIENT_SECRET=zzz \
#   AZURE_SUBSCRIPTION_ID=www \
#   ./credentials-secret.sh
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

: "${AZURE_TENANT_ID:?AZURE_TENANT_ID is required}"
: "${AZURE_CLIENT_ID:?AZURE_CLIENT_ID is required}"
: "${AZURE_CLIENT_SECRET:?AZURE_CLIENT_SECRET is required}"
: "${AZURE_SUBSCRIPTION_ID:?AZURE_SUBSCRIPTION_ID is required}"

kubectl create secret generic azure-credentials \
  --namespace crossplane-system \
  --from-literal=credentials="{
  \"clientId\": \"${AZURE_CLIENT_ID}\",
  \"clientSecret\": \"${AZURE_CLIENT_SECRET}\",
  \"tenantId\": \"${AZURE_TENANT_ID}\",
  \"subscriptionId\": \"${AZURE_SUBSCRIPTION_ID}\",
  \"activeDirectoryEndpointUrl\": \"https://login.microsoftonline.com\",
  \"resourceManagerEndpointUrl\": \"https://management.azure.com/\",
  \"activeDirectoryGraphResourceId\": \"https://graph.windows.net/\",
  \"sqlManagementEndpointUrl\": \"https://management.core.windows.net:8443/\",
  \"galleryEndpointUrl\": \"https://gallery.azure.com/\",
  \"managementEndpointUrl\": \"https://management.core.windows.net/\"
}" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "✅ azure-credentials secret created"
