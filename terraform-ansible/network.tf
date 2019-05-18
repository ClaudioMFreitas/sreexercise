resource "google_compute_subnetwork" "private-network-1" {
  name          = "${var.region1}-network"
  ip_cidr_range = "10.0.160.0/24"
  region        = "${var.region1}"
  network       = "${google_compute_network.private-network.self_link}"
  project       = "${google_project.project.project_id}"
}

resource "google_compute_subnetwork" "private-network-2" {
  name          = "${var.region2}-network"
  ip_cidr_range = "10.0.161.0/24"
  region        = "${var.region2}"
  network       = "${google_compute_network.private-network.self_link}"
  project       = "${google_project.project.project_id}"
}

resource "google_compute_network" "private-network" {
  name                    = "private-network"
  project                 = "${google_project.project.project_id}"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "default" {
  name = "basic-rules"
  network = "${google_compute_network.private-network.name}"
  project = "${google_project.project.project_id}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
}
