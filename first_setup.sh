#!/bin/bash

source vars.sh
set -e
set -o nounset

gcloud projects create "${TF_VAR_project_name}" --organization "${ORGANIZATION_ID}" --set-as-default
gcloud config set project "${TF_VAR_project_name}"
gcloud iam service-accounts create "${USERNAME}"
gcloud organizations add-iam-policy-binding 620865151323 --member serviceAccount:"${USERNAME}"@"${TF_VAR_project_name}".iam.gserviceaccount.com --role roles/resourcemanager.projectCreator --role roles/billing.user
gcloud projects add-iam-policy-binding "${TF_VAR_project_name}" --member serviceAccount:"${USERNAME}"@"${TF_VAR_project_name}".iam.gserviceaccount.com --role roles/storage.admin --role roles/owner
gcloud beta billing projects link "${TF_VAR_project_name}" --billing-account "${BILLING_ACCOUNT}"
gcloud services enable cloudbilling.googleapis.com compute.googleapis.com cloudresourcemanager.googleapis.com
gcloud iam service-accounts keys create ~/creds_file.json --iam-account "${USERNAME}"@"${TF_VAR_project_name}".iam.gserviceaccount.com
