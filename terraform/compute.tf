data "google_compute_zones" "available-region1" {
  region  = "${var.region1}"
}

data "google_compute_zones" "available-region2" {
  region  = "${var.region2}"
}

data "google_compute_instance_group" "r1" {
  name = "r1-instance"
  zone = "${data.google_compute_zones.available-region1.names[0]}"
}

resource "google_compute_instance_group_manager" "webserver-group-r1" {
  name               = "webserver-group-r1"
  base_instance_name = "webserver-r1"
  instance_template  = "${google_compute_instance_template.webservers.self_link}"
  zone               = "${data.google_compute_zones.available-region1.names[0]}"

  target_pools = [
    "${google_compute_target_pool.webserver-pool-r1.self_link}"
  ]
  target_size = 2

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_instance_group_manager" "webserver-group-r2" {
  name               = "webserver-group-r2"
  base_instance_name = "webserver-r2"
  instance_template  = "${google_compute_instance_template.webservers.self_link}"
  zone               = "${data.google_compute_zones.available-region2.names[0]}"

  target_pools = [
    "${google_compute_target_pool.webserver-pool-r2.self_link}"
  ]
  target_size = 2

  named_port {
    name = "http"
    port = 80
  }
}


resource "google_compute_instance_template" "webservers" {
  name = "webservers"
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
}
