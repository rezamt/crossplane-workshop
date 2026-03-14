#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# kind-setup.sh  —  Creates a local kind cluster for workshop use
#
# Prerequisites:
#   brew install kind kubectl cloud-provider-kind
#   Docker Desktop running
#
# Usage:
#   ./kind-setup.sh             # cluster name defaults to "workshop"
#   ./kind-setup.sh my-cluster  # custom name
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

CLUSTER_NAME="${1:-workshop}"
MEMORY_LIMIT="6g"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 1. Create the cluster ─────────────────────────────────────────────────────
echo "🚀 Creating kind cluster: ${CLUSTER_NAME}"
kind create cluster \
  --name "${CLUSTER_NAME}" \
  --config "${SCRIPT_DIR}/kind-config.yaml"

# ── 2. Cap memory on every node container ────────────────────────────────────
echo "🔧 Applying ${MEMORY_LIMIT} memory limit to all nodes..."
for node in $(kind get nodes --name "${CLUSTER_NAME}"); do
  docker update --memory "${MEMORY_LIMIT}" --memory-swap "${MEMORY_LIMIT}" "${node}"
  echo "   ✔ ${node}"
done

# ── 3. Start cloud-provider-kind (enables LoadBalancer on macOS) ──────────────
echo ""
echo "✅ Cluster ready!"
echo ""
kubectl cluster-info --context "kind-${CLUSTER_NAME}"
echo ""
kubectl get nodes -o wide
echo ""
echo "─────────────────────────────────────────────────────────────────────────"
echo "  LoadBalancer support requires cloud-provider-kind running in a"
echo "  separate terminal:"
echo ""
echo "    sudo cloud-provider-kind"
echo ""
echo "  To delete this cluster:"
echo "    kind delete cluster --name ${CLUSTER_NAME}"
echo "─────────────────────────────────────────────────────────────────────────"
