data "google_compute_zones" "available-region1" {
  region  = "${var.region1}"
  project = "${google_project_services.project.project}"
}

data "google_compute_zones" "available-region2" {
  region  = "${var.region2}"
  project = "${google_project_services.project.project}"
}

# resource "ansible_host" "load-balancer" {
#   inventory_hostname = "${google_compute_instance.load-balancer.network_interface.0.access_config.0.nat_ip}"
#   # groups = ["load-balancer-group"]
#   vars {
#     ansible_user = "jpgrego"
#   }
# }

# resource "ansible_group" "load-balancer-group" {
#   inventory_group_name = "load-balancer-group"
#   children = ["load-balancer"]
# }

resource "google_compute_instance" "load-balancer" {
  project = "${google_project_services.project.project}"
  zone    = "${data.google_compute_zones.available-region1.names[0]}"
  name    = "load-balancer"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-9"
    }
  }  
  network_interface {
    network = "${google_compute_network.private-network.name}"
    subnetwork = "${google_compute_subnetwork.private-network-1.self_link}"
    network_ip = "10.0.160.10"
    access_config {
      # nat_ip = "${google_compute_address.external-ip.address}"
    }
  }
}

resource "google_compute_instance" "webservers-1" {
  count   = 2
  project = "${google_project_services.project.project}"
  zone    = "${data.google_compute_zones.available-region1.names[0]}"
  name    = "region1-${count.index}"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-9"
    }
  }
  network_interface {
    network = "${google_compute_network.private-network.name}"
    subnetwork = "${google_compute_subnetwork.private-network-1.self_link}"
    network_ip = "10.0.160.${count.index + 2}"
    #access_config { } # remove
  }
}

resource "google_compute_instance" "webservers-2" {
  count   = 2
  project = "${google_project_services.project.project}"
  zone    = "${data.google_compute_zones.available-region2.names[0]}"
  name    = "region2-${count.index}"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-9"
    }
  }
  network_interface {
    network = "${google_compute_network.private-network.name}"
    subnetwork = "${google_compute_subnetwork.private-network-2.self_link}"
    network_ip = "10.0.161.${count.index + 2}"
    #access_config { } # remove
  }
}

output "load-balancer_instance_id" {
  value = "${google_compute_instance.load-balancer.self_link}"
}

output "region1_instance_ids" {
  value = "${google_compute_instance.webservers-1.*.self_link}"
}

output "region2_instance_ids" {
  value = "${google_compute_instance.webservers-2.*.self_link}"
}
