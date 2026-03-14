#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# install-argocd.sh  —  Installs latest ArgoCD on a kind cluster
#
# Usage:
#   ./install-argocd.sh
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

ARGOCD_VERSION="v3.3.3"

# ── 1. Install ArgoCD ─────────────────────────────────────────────────────────
echo "📦 Installing ArgoCD ${ARGOCD_VERSION}..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -n argocd \
  --server-side --force-conflicts \
  -f "https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

# ── 2. Wait for ArgoCD to be ready ───────────────────────────────────────────
echo "⏳ Waiting for ArgoCD server to be ready..."
kubectl wait --namespace argocd \
  --for=condition=available deployment/argocd-server \
  --timeout=120s

# ── 3. Expose ArgoCD via LoadBalancer ────────────────────────────────────────
echo "🌐 Exposing ArgoCD server as LoadBalancer..."
kubectl patch svc argocd-server -n argocd \
  -p '{"spec": {"type": "LoadBalancer"}}'

echo "⏳ Waiting for external IP..."
until kubectl get svc argocd-server -n argocd --no-headers | awk '{print $4}' | grep -qv '<pending>'; do
  sleep 2
done

ARGOCD_IP=$(kubectl get svc argocd-server -n argocd --no-headers | awk '{print $4}')

# ── 4. Get initial admin password ────────────────────────────────────────────
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d)

# ── 5. Install ArgoCD CLI (macOS) ─────────────────────────────────────────────
if ! command -v argocd &>/dev/null; then
  echo "🔧 Installing ArgoCD CLI..."
  brew install argocd
fi

echo ""
echo "🎉 ArgoCD ${ARGOCD_VERSION} is ready!"
echo "─────────────────────────────────────────────────────────────────────────"
echo "  UI:       https://${ARGOCD_IP}"
echo "  Username: admin"
echo "  Password: ${ARGOCD_PASSWORD}"
echo ""
echo "  Login via CLI:"
echo "    argocd login ${ARGOCD_IP} --username admin --password '${ARGOCD_PASSWORD}' --insecure"
echo "─────────────────────────────────────────────────────────────────────────"
