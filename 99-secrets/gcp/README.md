# 1. Create a service account key in GCP
gcloud iam service-accounts keys create key.json \
  --iam-account=crossplane-sa@YOUR_PROJECT.iam.gserviceaccount.com

# 2. Create the secret
GCP_CREDENTIALS_FILE=./key.json ./providers/gcp/credentials-secret.sh

# 3. Update providerconfig.yaml with your project ID
#    Replace YOUR_GCP_PROJECT_ID before committing