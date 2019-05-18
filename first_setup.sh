#!/bin/bash
# this script assumes GOOGLE_APPLICATION_CREDENTIALS have been set, and that a
# key on $HOME/.ssh called "google_compute_engine" has its public counterpart on
# the machines

set -e

pushd terraform-ansible
sed -ri 's/(#access_config)/access_config/' compute.tf
terraform plan -out ~/current_plan.tf
terraform apply ~/current_plan.tf

# giving it time
sleep 5

ansible-playbook -i /home/jpgrego/go/bin/terraform-inventory deploy_nginx.yml \
                 --private-key ~/.ssh/google_compute_engine
ansible-playbook -i /home/jpgrego/go/bin/terraform-inventory deploy_nodejs.yml \
                 --private-key ~/.ssh/google_compute_engine

# hacky way to remove external interfaces on web machines...
sed -ri 's/(access_config \{ \} # remove)/#\1/' compute.tf
terraform plan -out ~/current_plan.tf
terraform apply ~/current_plan.tf
