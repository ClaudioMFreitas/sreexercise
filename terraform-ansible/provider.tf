variable "project_name" {}
variable "region1" {}
variable "region2" {}
variable "billing_account" {}
variable "org_id"  {}
variable "ssh_user" {}
variable "ssh_pub_key_file" {}

provider "google" {
  project = "${var.project_name}"
  region  = "${var.region1}"
}

#resource "random_id" "id" {
#  byte_length  = 4
#  prefix      = "${var.project_name}-"
#}

resource "google_project" "project" {
  name                 = "${var.project_name}"
  project_id           = "${var.project_name}"
  billing_account      = "${var.billing_account}"
  org_id               = "${var.org_id}"
}

resource "google_project_services" "project" {
  disable_on_destroy   = false
  project              = "${google_project.project.project_id}"
  services             = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "oslogin.googleapis.com",
    "iamcredentials.googleapis.com"
  ]
}

output "project_id" {
  value = "${google_project.project.project_id}"
}
