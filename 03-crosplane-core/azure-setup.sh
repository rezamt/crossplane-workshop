#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# azure-setup.sh  —  Installs Upbound provider-family-azure
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

PROVIDER_AZURE_VERSION="v2.5.0"

echo "📦 Installing provider-family-azure ${PROVIDER_AZURE_VERSION}..."
kubectl apply -f - <<EOF
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: upbound-provider-family-azure
spec:
  package: xpkg.upbound.io/upbound/provider-family-azure:${PROVIDER_AZURE_VERSION}
EOF

echo "✅ provider-family-azure applied"
