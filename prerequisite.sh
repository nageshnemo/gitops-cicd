#!/bin/bash

# === Variables ===
export PROJECT_ID="fast-ability-439911-u1"  # Replace with your GCP Project ID
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
export REGION="us-central1"  # Replace with your desired region
export SERVICE_ACCOUNT_NAME="gitops-cicd"
export BUCKET_NAME="terraform-state-bucket-009876"  # Replace with your desired bucket name
export WIF_POOL_NAME="gitops-github-identity-pool"  # Replace with your Workload Identity Pool name
export WIF_PROVIDER_NAME="gitops-github-idp"  # Replace with your Provider name
export REPO_NAME="nageshnemo/gitops-cicd"  # Replace with your GitHub repository name

# === 1. Create a storage bucket for Terraform state ===
if ! gsutil ls -b "gs://$BUCKET_NAME" >/dev/null 2>&1; then
  echo "Creating a storage bucket for Terraform state..."
  gcloud storage buckets create gs://$BUCKET_NAME \
    --location=$REGION \
    --uniform-bucket-level-access
else
  echo "Bucket $BUCKET_NAME already exists."
fi

# === 2. Create the service account ===
if ! gcloud iam service-accounts describe "$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" >/dev/null 2>&1; then
  echo "Creating the service account..."
  gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
    --description="Service Account for GitOps CI/CD" \
    --display-name="GitOps CI"
else
  echo "Service account $SERVICE_ACCOUNT_NAME already exists."
fi

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
if ! gcloud iam workload-identity-pools describe "$WIF_POOL_NAME" --location="global" --project="$PROJECT_ID" >/dev/null 2>&1; then
  gcloud iam workload-identity-pools create "$WIF_POOL_NAME" \
    --project="$PROJECT_ID" \
    --location="global" \
    --display-name="GitHub Actions Pool"
else
  echo "Workload Identity Pool $WIF_POOL_NAME already exists."
fi

# === 5. Create Workload Identity Provider ===
echo "Creating Workload Identity Provider..."
if ! gcloud iam workload-identity-pools providers describe "$WIF_PROVIDER_NAME" \
  --location="global" \
  --workload-identity-pool="$WIF_POOL_NAME" \
  --project="$PROJECT_ID" >/dev/null 2>&1; then
  gcloud iam workload-identity-pools providers create-oidc "$WIF_PROVIDER_NAME" \
    --project="$PROJECT_ID" \
    --location="global" \
    --workload-identity-pool="$WIF_POOL_NAME" \
    --display-name="My GitHub Repo Provider" \
    --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner" \
    --issuer-uri="https://token.actions.githubusercontent.com"
else
  echo "Workload Identity Provider $WIF_PROVIDER_NAME already exists."
fi

# === 6. Bind the service account to the Workload Identity Pool ===
echo "Binding the service account to the Workload Identity Pool..."
gcloud iam service-accounts add-iam-policy-binding "$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --project="$PROJECT_ID" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$WIF_POOL_NAME/attribute.repository/$REPO_NAME"

echo "Setup complete!"
