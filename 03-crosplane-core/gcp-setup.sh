#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# gcp-setup.sh  —  Installs Upbound provider-family-gcp
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

PROVIDER_GCP_VERSION="latest"

echo "📦 Installing provider-family-gcp ${PROVIDER_GCP_VERSION}..."
kubectl apply -f - <<EOF
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: upbound-provider-family-gcp
spec:
  package: xpkg.upbound.io/upbound/provider-family-gcp:${PROVIDER_GCP_VERSION}
EOF

echo "✅ provider-family-gcp applied"
