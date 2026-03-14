#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# setup.sh  —  Main workshop setup orchestrator
#
# Always installs: Crossplane core
# Optional providers via flags:
#
# Usage:
#   ./setup.sh                                        # crossplane only
#   ./setup.sh --all                                  # everything
#   ./setup.sh --aws --azure --azuread                # specific providers
#
# Flags:
#   --all          All providers
#   --aws          provider-family-aws
#   --azure        provider-family-azure
#   --azuread      provider-azuread
#   --gcp          provider-family-gcp
#   --helm         provider-helm
#   --kubernetes   provider-kubernetes
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Parse flags ───────────────────────────────────────────────────────────────
INSTALL_AWS=false
INSTALL_AZURE=false
INSTALL_AZUREAD=false
INSTALL_GCP=false
INSTALL_HELM=false
INSTALL_K8S=false

for arg in "$@"; do
  case $arg in
    --all)        INSTALL_AWS=true; INSTALL_AZURE=true; INSTALL_AZUREAD=true; INSTALL_GCP=true; INSTALL_HELM=true; INSTALL_K8S=true ;;
    --aws)        INSTALL_AWS=true ;;
    --azure)      INSTALL_AZURE=true ;;
    --azuread)    INSTALL_AZUREAD=true ;;
    --gcp)        INSTALL_GCP=true ;;
    --helm)       INSTALL_HELM=true ;;
    --kubernetes) INSTALL_K8S=true ;;
    *) echo "Unknown flag: $arg"; exit 1 ;;
  esac
done

# ── 1. Always install Crossplane core ────────────────────────────────────────
bash "${SCRIPT_DIR}/crossplane-setup.sh"

# ── 2. Install selected providers ────────────────────────────────────────────
PROVIDER_COUNT=0

run_provider() {
  local script=$1
  bash "${SCRIPT_DIR}/${script}"
  PROVIDER_COUNT=$((PROVIDER_COUNT + 1))
}

[[ "${INSTALL_AWS}"     == true ]] && run_provider "aws-setup.sh"
[[ "${INSTALL_AZURE}"   == true ]] && run_provider "azure-setup.sh"
[[ "${INSTALL_AZUREAD}" == true ]] && run_provider "azuread-setup.sh"
[[ "${INSTALL_GCP}"     == true ]] && run_provider "gcp-setup.sh"
[[ "${INSTALL_HELM}"    == true ]] && run_provider "helm-setup.sh"
[[ "${INSTALL_K8S}"     == true ]] && run_provider "kubernetes-setup.sh"

# ── 3. Wait for all providers to become healthy ───────────────────────────────
if [[ "${PROVIDER_COUNT}" -gt 0 ]]; then
  echo ""
  echo "⏳ Waiting for ${PROVIDER_COUNT} provider(s) to become healthy..."
  echo "   Pulling images from xpkg.upbound.io (may take a few minutes)..."

  TIMEOUT=300
  ELAPSED=0
  while true; do
    TOTAL=$(kubectl get providers --no-headers 2>/dev/null | wc -l | tr -d ' ')
    HEALTHY=$(kubectl get providers --no-headers 2>/dev/null | awk '{print $3}' | grep -c "True" || true)

    echo "   Providers healthy: ${HEALTHY}/${TOTAL}"

    if [[ "${TOTAL}" -ge "${PROVIDER_COUNT}" && "${HEALTHY}" -ge "${TOTAL}" ]]; then
      break
    fi

    if [[ "${ELAPSED}" -ge "${TIMEOUT}" ]]; then
      echo "⚠️  Timeout — check status with: kubectl get providers"
      break
    fi

    sleep 10
    ELAPSED=$((ELAPSED + 10))
  done
fi

# ── 4. Summary ────────────────────────────────────────────────────────────────
echo ""
echo "🎉 Setup complete!"
echo "─────────────────────────────────────────────────────────────────────────"
kubectl get providers 2>/dev/null || echo "  No providers installed"
echo ""
echo "  Browse providers: https://marketplace.upbound.io"
echo "─────────────────────────────────────────────────────────────────────────"
