#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Creates the GCP credentials secret for Crossplane
#
# Prerequisites:
#   - A GCP Service Account with required permissions
#   - A JSON key file downloaded from GCP Console or created via:
#       gcloud iam service-accounts keys create key.json \
#         --iam-account=<sa-name>@<project>.iam.gserviceaccount.com
#
# Usage:
#   GCP_CREDENTIALS_FILE=./key.json ./credentials-secret.sh
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

: "${GCP_CREDENTIALS_FILE:?GCP_CREDENTIALS_FILE is required (path to service account JSON key)}"

if [[ ! -f "${GCP_CREDENTIALS_FILE}" ]]; then
  echo "❌ File not found: ${GCP_CREDENTIALS_FILE}"
  exit 1
fi

kubectl create secret generic gcp-credentials \
  --namespace crossplane-system \
  --from-file=credentials="${GCP_CREDENTIALS_FILE}" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "✅ gcp-credentials secret created"