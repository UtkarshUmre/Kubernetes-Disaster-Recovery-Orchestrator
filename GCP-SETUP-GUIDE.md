# 🌟 Google Cloud Setup Guide for K8s Disaster Recovery

This guide will help you set up everything on Google Cloud Platform from scratch.

## 📋 Prerequisites

You'll need:
- A Google Cloud account with billing enabled
- `gcloud` CLI installed on your laptop ([Install Guide](https://cloud.google.com/sdk/docs/install))
- Basic familiarity with GCP Console

## 🚀 Step-by-Step Setup

### Step 1: Create a New GCP Project

```bash
# Login to GCP
gcloud auth login

# Create a new project for the hackathon
gcloud projects create kestra-k8s-dr-demo --name="Kestra K8s DR Demo"

# Set it as active project
gcloud config set project kestra-k8s-dr-demo

# Enable billing (required for GKE)
# Visit: https://console.cloud.google.com/billing
```

### Step 2: Enable Required APIs

```bash
# Enable necessary APIs
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
```

### Step 3: Create a GKE Cluster (Your Kubernetes Cluster)

```bash
# Create a small GKE cluster (minimal resources to save costs)
gcloud container clusters create kestra-demo-cluster \
    --zone us-central1-a \
    --num-nodes 2 \
    --machine-type e2-small \
    --disk-size 20 \
    --enable-autorepair \
    --enable-autoupgrade

# Get credentials for kubectl
gcloud container clusters get-credentials kestra-demo-cluster --zone us-central1-a

# Verify connection
kubectl get nodes
```

### Step 4: Create Google Cloud Storage Bucket

```bash
# Create a GCS bucket for backups
gsutil mb -c standard -l us-central1 gs://k8s-dr-backups-$USER

# Note: Replace $USER with a unique identifier if bucket name is taken
```

### Step 5: Create Service Account for Kestra

```bash
# Create service account
gcloud iam service-accounts create kestra-dr-sa \
    --display-name="Kestra DR Service Account"

# Grant necessary permissions
gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
    --member="serviceAccount:kestra-dr-sa@$(gcloud config get-value project).iam.gserviceaccount.com" \
    --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
    --member="serviceAccount:kestra-dr-sa@$(gcloud config get-value project).iam.gserviceaccount.com" \
    --role="roles/container.developer"

# Create and download service account key
gcloud iam service-accounts keys create ~/kestra-dr-key.json \
    --iam-account=kestra-dr-sa@$(gcloud config get-value project).iam.gserviceaccount.com

echo "Service account key saved to: ~/kestra-dr-key.json"
```

### Step 6: Deploy Kestra on Google Cloud Run

```bash
# Create a simple Kestra configuration
cat > kestra-config.yml <<EOF
kestra:
  server:
    basic-auth:
      enabled: false
  repository:
    type: memory
  storage:
    type: local
    local:
      base-path: "/tmp/kestra/storage"
  queue:
    type: memory
EOF

# Deploy Kestra on Cloud Run (serverless, no VMs needed!)
gcloud run deploy kestra \
    --image kestra/kestra:latest \
    --platform managed \
    --region us-central1 \
    --allow-unauthenticated \
    --memory 2Gi \
    --cpu 2 \
    --port 8080 \
    --max-instances 1 \
    --set-env-vars="KESTRA_CONFIGURATION_PATH=/tmp/kestra-config.yml"

# Get the URL
KESTRA_URL=$(gcloud run services describe kestra --region us-central1 --format 'value(status.url)')
echo "Kestra is running at: $KESTRA_URL"
```

### Step 7: Create Demo Resources in Kubernetes

```bash
# Create some demo apps to backup
kubectl create namespace demo-app

# Deploy a simple web app
kubectl create deployment nginx-demo --image=nginx:alpine -n demo-app
kubectl expose deployment nginx-demo --port=80 --type=LoadBalancer -n demo-app

# Create a stateful app with persistent volume
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: demo-data
  namespace: demo-app
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-demo
  namespace: demo-app
spec:
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:5.7
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "hackathon123"
        volumeMounts:
        - name: mysql-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-storage
        persistentVolumeClaim:
          claimName: demo-data
EOF

echo "✅ Demo apps created!"
kubectl get all -n demo-app
```

### Step 8: Prepare Secrets for Kestra

```bash
# Get your kubeconfig
KUBECONFIG_CONTENT=$(cat ~/.kube/config | base64 -w 0)

# Get service account JSON
GCP_SA_JSON=$(cat ~/kestra-dr-key.json | base64 -w 0)

# Create a script to add secrets to Kestra
cat > setup-kestra-secrets.sh <<EOF
#!/bin/bash

KESTRA_URL="$KESTRA_URL"

# Create namespace
curl -X POST \${KESTRA_URL}/api/v1/namespaces -H "Content-Type: application/json" -d '{"id": "demo"}'

# Add secrets
echo "Adding KUBECONFIG_CONTENT..."
curl -X POST \${KESTRA_URL}/api/v1/namespaces/demo/secrets \
  -H "Content-Type: application/json" \
  -d '{"key": "KUBECONFIG_CONTENT", "value": "'$KUBECONFIG_CONTENT'"}'

echo "Adding GCP_SERVICE_ACCOUNT_JSON..."
curl -X POST \${KESTRA_URL}/api/v1/namespaces/demo/secrets \
  -H "Content-Type: application/json" \
  -d '{"key": "GCP_SERVICE_ACCOUNT_JSON", "value": "'$GCP_SA_JSON'"}'

echo "Adding GCP_PROJECT_ID..."
curl -X POST \${KESTRA_URL}/api/v1/namespaces/demo/secrets \
  -H "Content-Type: application/json" \
  -d '{"key": "GCP_PROJECT_ID", "value": "'$(gcloud config get-value project)'"}'

echo "✅ Secrets created!"
EOF

chmod +x setup-kestra-secrets.sh
./setup-kestra-secrets.sh
```

### Step 9: Upload the Workflow

1. Open Kestra UI in your browser: Visit the URL from Step 6
2. Go to "Flows" → "Create"
3. Copy the content from `k8s-disaster-recovery.yml`
4. Paste and save

### Step 10: Update the Workflow for Your GCS Bucket

In the workflow, update this line:
```yaml
variables:
  backupStorage: "gs://k8s-dr-backups-YOUR-USERNAME"  # Update with your bucket name
```

## 🎮 Demo Time!

### 1. Create a Backup
- Go to Kestra UI
- Find your workflow
- Click "Execute"
- Select `action: backup`
- Run it!

### 2. Verify Backup in GCS
```bash
# List your backups
gsutil ls gs://k8s-dr-backups-$USER/

# You should see something like:
# gs://k8s-dr-backups-user/backup-20240116-150000.tar.gz
```

### 3. Simulate Disaster
```bash
# Delete the demo namespace
kubectl delete namespace demo-app

# Verify it's gone
kubectl get namespace demo-app
# Should show: Error from server (NotFound)
```

### 4. Restore from Backup
- Go to Kestra UI
- Execute the workflow
- Select `action: restore`
- Enter the backup ID (e.g., `backup-20240116-150000`)
- Run it!

### 5. Verify Restoration
```bash
# Check if namespace is back
kubectl get all -n demo-app

# Your apps should be restored!
```

### 6. Generate Beautiful Report
- Execute workflow with `action: report`
- Download the HTML file
- Open in browser and show the judges!

## 💰 Cost Optimization Tips

To minimize costs during development:

```bash
# Stop your GKE cluster when not in use
gcloud container clusters resize kestra-demo-cluster --num-nodes=0 --zone us-central1-a

# Start it again when needed
gcloud container clusters resize kestra-demo-cluster --num-nodes=2 --zone us-central1-a

# Delete everything after the hackathon
gcloud projects delete kestra-k8s-dr-demo
```

## 🚨 Troubleshooting

### If Kestra on Cloud Run has issues:
```bash
# Check logs
gcloud run services logs read kestra --region us-central1

# Redeploy with more memory
gcloud run services update kestra --memory 4Gi --region us-central1
```

### If backup fails:
```bash
# Check GCS permissions
gsutil ls gs://k8s-dr-backups-$USER/

# Test service account
gcloud auth activate-service-account --key-file=~/kestra-dr-key.json
gsutil ls
```

### If restore fails:
```bash
# Check kubeconfig
kubectl config current-context

# Ensure you're connected to GKE
gcloud container clusters get-credentials kestra-demo-cluster --zone us-central1-a
```

## 🎯 Quick Commands Cheatsheet

```bash
# Your Kestra URL
echo $KESTRA_URL

# List backups
gsutil ls gs://k8s-dr-backups-$USER/

# Watch Kubernetes resources
watch kubectl get all -n demo-app

# Check Kestra logs
gcloud run services logs read kestra --region us-central1 --limit 50

# Get cluster status
gcloud container clusters describe kestra-demo-cluster --zone us-central1-a
```

## 🏆 Demo Script for Judges

"I'm running everything on Google Cloud - Kestra on Cloud Run (serverless!), GKE for Kubernetes, and GCS for backup storage. Let me show you how my creative workflow protects against disasters..."

[Show the beautiful Kestra UI running on Cloud Run URL]

"Watch as I backup this entire Kubernetes cluster with one click..."

[Execute backup, then show the backup in GCS]

"Now let's simulate a disaster..."

[Delete namespace, then restore it]

"And here's the magic - a beautiful report generated automatically!"

[Show the HTML report]

## 📝 Remember

- Everything is running on Google Cloud (no local resources needed!)
- Kestra on Cloud Run = No VMs to manage
- GKE cluster can be stopped to save money
- All backups are in GCS (highly durable)
- The creativity is in the single workflow doing 5 different jobs!

Good luck with your hackathon! 🚀
