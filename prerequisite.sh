#!/bin/bash

# === Variables ===
export PROJECT_ID="fast-ability-439911-u1"  # Replace with your GCP Project ID
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
export REGION="us-central1"  # Replace with your desired region
export SERVICE_ACCOUNT_NAME="gitops-cicd"
export BUCKET_NAME="terraform-state-bucket-0001120"  # Replace with your desired bucket name
export WIF_POOL_NAME="github"
export WIF_PROVIDER_NAME="my-repo"
export REPO_NAME="nageshnemo/gitops-cicd"  # Replace with your GitHub repository name
export GITHUB_ORG="nageshnemo"  # Replace with your GitHub organization

# === 1. Create a storage bucket for Terraform state ===
echo "Creating a storage bucket for Terraform state..."
gcloud storage buckets create "gs://$BUCKET_NAME" \
  --location=$REGION \
  --uniform-bucket-level-access || echo "Bucket $BUCKET_NAME already exists."

# === 2. Create the service account ===
echo "Creating the service account..."
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --description="Service Account for GitOps CI/CD" \
  --display-name="GitOps CI/CD Service Account" || echo "Service account $SERVICE_ACCOUNT_NAME already exists."

# === 3. Assign IAM roles to the service account ===
echo "Assigning roles to the service account..."
roles=(
  "roles/storage.objectAdmin"
  "roles/storage.objectViewer"
  "roles/artifactregistry.writer"
  "roles/container.admin"
)
for role in "${roles[@]}"; do
  gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="$role" --quiet
done

# === 4. Create Workload Identity Pool ===
echo "Creating Workload Identity Pool..."
gcloud iam workload-identity-pools create "$WIF_POOL_NAME" \
  --project="$PROJECT_ID" \
  --location="global" \
  --display-name="GitHub Actions Pool" || echo "Workload Identity Pool $WIF_POOL_NAME already exists."

# === 5. Create Workload Identity Provider ===
echo "Creating Workload Identity Provider..."
gcloud iam workload-identity-pools providers create-oidc "$WIF_PROVIDER_NAME" \
  --project="$PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="$WIF_POOL_NAME" \
  --display-name="My GitHub Repo Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner" \
  --attribute-condition="assertion.repository_owner == '$GITHUB_ORG'" \
  --issuer-uri="https://token.actions.githubusercontent.com" || echo "Workload Identity Provider $WIF_PROVIDER_NAME already exists."

# === 6. Bind the service account to the Workload Identity Pool ===
echo "Binding the service account to the Workload Identity Pool..."
gcloud iam service-accounts add-iam-policy-binding "$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --project="$PROJECT_ID" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$WIF_POOL_NAME/attribute.repository/$REPO_NAME"

echo "Setup complete!"
