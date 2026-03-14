#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Creates the AWS credentials secret for Crossplane
#
# Usage:
#   AWS_ACCESS_KEY_ID=xxx AWS_SECRET_ACCESS_KEY=yyy ./credentials-secret.sh
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

: "${AWS_ACCESS_KEY_ID:?AWS_ACCESS_KEY_ID is required}"
: "${AWS_SECRET_ACCESS_KEY:?AWS_SECRET_ACCESS_KEY is required}"
AWS_REGION="${AWS_REGION:-us-east-1}"

kubectl create secret generic aws-credentials \
  --namespace crossplane-system \
  --from-literal=credentials="[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
region = ${AWS_REGION}" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "✅ aws-credentials secret created"
