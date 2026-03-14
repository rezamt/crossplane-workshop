#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# helm-setup.sh  —  Installs Upbound provider-helm
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

PROVIDER_HELM_VERSION="latest"

echo "📦 Installing provider-helm ${PROVIDER_HELM_VERSION}..."
kubectl apply -f - <<EOF
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: upbound-provider-helm
spec:
  package: xpkg.upbound.io/crossplane-contrib/provider-helm:${PROVIDER_HELM_VERSION}
EOF

echo "✅ provider-helm applied"
