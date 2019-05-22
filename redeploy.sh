#!/bin/bash

set -e
set -o nounset
source vars.sh

if [ -z "$1" ]; then
    echo "usage: first_setup.sh <version>"
    exit 1
fi

export TF_VAR_meme_version="$1"

if ! gcloud compute images describe debian9-meme-image-v"${TF_VAR_meme_version}" > /dev/null 2>&1; then
    packer build packer-meme-image.json
fi

pushd terraform
if [ ! -f terraform.tfstate ]; then
    terraform import google_project.project "${PROJECT_NAME}"
    terraform import google_project_services.project "${PROJECT_NAME}"
fi
terraform plan -out ~/current_plan.tf
terraform apply ~/current_plan.tf
