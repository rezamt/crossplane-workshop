#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# azuread-setup.sh  —  Installs Upbound provider-azuread
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

PROVIDER_AZUREAD_VERSION="v2.2.1"

echo "📦 Installing provider-azuread ${PROVIDER_AZUREAD_VERSION}..."
kubectl apply -f - <<EOF
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: upbound-provider-azuread
spec:
  package: xpkg.upbound.io/upbound/provider-azuread:${PROVIDER_AZUREAD_VERSION}
EOF

echo "✅ provider-azuread applied"
