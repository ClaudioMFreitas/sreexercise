#!/bin/bash

readonly PROJECT_NAME="thememes"

# set -e
# gcloud projects create "${PROJECT_NAME}" --organization "${ORGANIZATION_ID}" --set-as-default
# gcloud config set project "${PROJECT_NAME}"
# gcloud iam service-accounts create theboss
# gcloud projects add-iam-policy-binding "${PROJECT_NAME}" --member serviceAccount:theboss@"${PROJECT_NAME}".iam.gserviceaccount.com --role roles/storage.admin --role roles/owner
# gcloud beta billing projects link "${PROJECT_NAME}" --billing-account "${BILLING_ACCOUNT}"
# gcloud services enable cloudbilling.googleapis.com compute.googleapis.com cloudresourcemanager.googleapis.com
# gcloud organizations add-iam-policy-binding 620865151323 --member serviceAccount:theboss@"${PROJECT_NAME}".iam.gserviceaccount.com --role roles/resourcemanager.projectCreator --role roles/billing.user

packer build packer-meme-image.json

set -e
pushd terraform
if [ ! -f terraform.tfstate ]; then
    terraform import google_project.project "${PROJECT_NAME}"
    terraform import google_project_services.project "${PROJECT_NAME}"
fi
terraform plan -out ~/current_plan.tf
terraform apply ~/current_plan.tf
