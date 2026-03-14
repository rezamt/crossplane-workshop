#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# crossplane-setup.sh  —  Installs Crossplane core via Helm
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

CROSSPLANE_VERSION="2.2.0"

echo "📦 Installing Crossplane v${CROSSPLANE_VERSION}..."
helm repo add crossplane-stable https://charts.crossplane.io/stable --force-update
helm repo update

helm upgrade --install crossplane crossplane-stable/crossplane \
  --namespace crossplane-system \
  --create-namespace \
  --version "${CROSSPLANE_VERSION}" \
  --wait

echo "⏳ Waiting for Crossplane pods..."
kubectl wait --namespace crossplane-system \
  --for=condition=available deployment/crossplane \
  --timeout=120s

echo "✅ Crossplane v${CROSSPLANE_VERSION} ready"
