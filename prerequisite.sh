#!/bin/bash

# Set environment variables
export PROJECT_ID="fast-ability-439911-u1"
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
export REGION="us-central1"
export SERVICE_ACCOUNT_NAME="gitops-ci"
export BUCKET_NAME="terraform-state-bucket"
export WIF_POOL_NAME="gitops-ci-pool"
export WIF_PROVIDER_NAME="gitops-ci-provider"
export REPO_NAME="nageshnemo/gitops-cicd"

# Create a storage bucket for Terraform state
echo "Creating a storage bucket for Terraform state..."
gcloud storage buckets create gs://$BUCKET_NAME --location=$REGION --uniform-bucket-level-access

# Create the service account
echo "Creating the service account..."
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --description="Service Account for GitOps CI/CD" \
  --display-name="GitOps CI"

# Assign project-level IAM roles to the service account
echo "Assigning roles to the service account..."
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.objectViewer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/container.admin"

# Create Workload Identity Pool
echo "Creating the Workload Identity Pool..."
gcloud iam workload-identity-pools create "$WIF_POOL_NAME" \
  --project="$PROJECT_ID" \
  --location="global" \
  --display-name="GitOps CI Pool"

# Create Workload Identity Provider
echo "Creating the Workload Identity Provider..."
gcloud iam workload-identity-pools providers create-oidc "$WIF_PROVIDER_NAME" \
  --project="$PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="$WIF_POOL_NAME" \
  --display-name="GitHub Actions Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com"

# Bind Workload Identity Pool to the Service Account
echo "Binding Workload Identity Pool to the Service Account..."
gcloud iam service-accounts add-iam-policy-binding "$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --project="$PROJECT_ID" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$WIF_POOL_NAME/attribute.repository/$REPO_NAME"

echo "Configuration complete!"
