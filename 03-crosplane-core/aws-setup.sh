#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# aws-setup.sh  —  Installs Upbound provider-family-aws
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

PROVIDER_AWS_VERSION="v1.23.2"

echo "📦 Installing provider-family-aws ${PROVIDER_AWS_VERSION}..."
kubectl apply -f - <<EOF
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: upbound-provider-family-aws
spec:
  package: xpkg.upbound.io/upbound/provider-family-aws:${PROVIDER_AWS_VERSION}
EOF

echo "✅ provider-family-aws applied"
