#!/bin/bash
# Template for creating Kestra secrets for Google Cloud
# Run this after setting up GCP resources

# Set your Kestra URL (from Cloud Run deployment)
KESTRA_URL="${KESTRA_URL:-https://your-kestra-url.run.app}"

# Create secrets
echo "Creating Kestra secrets for Google Cloud..."

# Kubeconfig (base64 encoded)
echo "Adding kubeconfig..."
KUBECONFIG_CONTENT=$(cat ~/.kube/config | base64 -w 0)
curl -X POST ${KESTRA_URL}/api/v1/namespaces/demo/secrets \
  -H "Content-Type: application/json" \
  -d "{\"key\": \"KUBECONFIG_CONTENT\", \"value\": \"$KUBECONFIG_CONTENT\"}"

# GCP Service Account JSON (base64 encoded)
echo "Adding GCP service account..."
GCP_SA_JSON=$(cat ~/kestra-dr-key.json | base64 -w 0)
curl -X POST ${KESTRA_URL}/api/v1/namespaces/demo/secrets \
  -H "Content-Type: application/json" \
  -d "{\"key\": \"GCP_SERVICE_ACCOUNT_JSON\", \"value\": \"$GCP_SA_JSON\"}"

# GCP Project ID
echo "Adding GCP project ID..."
GCP_PROJECT=$(gcloud config get-value project)
curl -X POST ${KESTRA_URL}/api/v1/namespaces/demo/secrets \
  -H "Content-Type: application/json" \
  -d "{\"key\": \"GCP_PROJECT_ID\", \"value\": \"$GCP_PROJECT\"}"

# Slack webhook (optional but recommended)
echo "Adding Slack webhook (optional)..."
curl -X POST ${KESTRA_URL}/api/v1/namespaces/demo/secrets \
  -H "Content-Type: application/json" \
  -d '{"key": "SLACK_WEBHOOK_URL", "value": "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"}'

echo "✅ Secrets created successfully!"
echo ""
echo "Now you can upload k8s-disaster-recovery.yml to Kestra!"
