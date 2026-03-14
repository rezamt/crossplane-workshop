#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# kubernetes-setup.sh  —  Installs Upbound provider-kubernetes
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

PROVIDER_K8S_VERSION="latest"

echo "📦 Installing provider-kubernetes ${PROVIDER_K8S_VERSION}..."
kubectl apply -f - <<EOF
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: upbound-provider-kubernetes
spec:
  package: xpkg.upbound.io/crossplane-contrib/provider-kubernetes:${PROVIDER_K8S_VERSION}
EOF

echo "✅ provider-kubernetes applied"
