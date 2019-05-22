# data "google_compute_zones" "available-region1" {
#   region  = "${var.region1}"
# }

# data "google_compute_zones" "available-region2" {
#   region  = "${var.region2}"
# }

resource "google_compute_region_instance_group_manager" "webserver-group-r1" {
  name               = "webserver-group-r1"
  provider           = "google-beta"
  base_instance_name = "webserver-r1"
  region             = "${var.region1}"
  
  target_size = 4

  named_port {
    name = "http"
    port = 80
  }

  update_policy {
    type = "PROACTIVE"
    minimal_action = "REPLACE"
    max_unavailable_fixed = 3
  }

  version {
    name = "default-version"
    instance_template  = "${google_compute_instance_template.webservers.self_link}"
  }
  
}

resource "google_compute_region_instance_group_manager" "webserver-group-r2" {
  name               = "webserver-group-r2"
  provider           = "google-beta"
  base_instance_name = "webserver-r2"
  region             = "${var.region2}"
  
  target_size = 4

  named_port {
    name = "http"
    port = 80
  }

  update_policy{
    type = "PROACTIVE"
    minimal_action = "REPLACE"
    max_unavailable_fixed = 3
  }

  version {
    name = "default-version"
    instance_template  = "${google_compute_instance_template.webservers.self_link}"
  }
  
}

resource "google_compute_instance_template" "webservers" {
  name_prefix = "webservers-"
  tags = ["web"]
  machine_type = "f1-micro"
  
  scheduling {
    automatic_restart = true
  }

  disk {
    source_image = "${google_project_services.project.project}/debian9-meme-image-v${var.meme_version}"
    auto_delete  = false
    boot         = true
  }

  network_interface {
    network = "default"
    # access_config { } # remove
  }

  lifecycle {
    create_before_destroy = true
  }
}
