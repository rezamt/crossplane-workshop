#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# apps-setup.sh  —  Applies ArgoCD Applications from the apps/ folder
#
# Usage:
#   ./apps-setup.sh                                   # apply all
#   ./apps-setup.sh crossplane                        # crossplane only
#   ./apps-setup.sh crossplane provider-aws provider-azuread
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPS_DIR="${SCRIPT_DIR}/apps"

ALL_APPS="crossplane provider-aws provider-azure provider-azuread provider-gcp provider-helm provider-kubernetes"

if [[ $# -eq 0 ]]; then
  SELECTED="${ALL_APPS}"
else
  SELECTED="$*"
fi

echo "🚀 Applying ArgoCD Applications..."
for app in ${SELECTED}; do
  manifest="${APPS_DIR}/${app}.yaml"
  if [[ ! -f "${manifest}" ]]; then
    echo "❌ No manifest found for '${app}' at ${manifest}"
    exit 1
  fi
  kubectl apply -f "${manifest}"
  echo "   ✔ ${app}"
done

echo ""
echo "⏳ Watching sync status (Ctrl+C to exit)..."
kubectl get applications -n argocd -w