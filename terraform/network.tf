resource "google_compute_global_address" "external-addr" {
  name = "external-addr"
}

resource "google_compute_backend_service" "backend-service" {
  name = "backend-service"
  protocol = "HTTP"
  health_checks = [
    "${google_compute_http_health_check.health_check.self_link}"
  ]

  backend  {
    group = "${google_compute_instance_group_manager.webserver-group-r1.instance_group}"
  }

  backend {
    group = "${google_compute_instance_group_manager.webserver-group-r2.instance_group}"
  }
}

resource "google_compute_global_forwarding_rule" "forwarding-rule" {
  name       = "forwarding-rule"
  target     = "${google_compute_target_http_proxy.http-proxy.self_link}"
  port_range = "80"
  ip_address    = "${google_compute_global_address.external-addr.address}"
}

resource "google_compute_url_map" "urlmap" {
  name = "urlmap"
  default_service = "${google_compute_backend_service.backend-service.self_link}"
}

resource "google_compute_target_http_proxy" "http-proxy" {
  name = "http-proxy"
  url_map = "${google_compute_url_map.urlmap.self_link}"
}

# even though this one is legacy, it's still the one to use if one uses the
# network load balancer
resource "google_compute_http_health_check" "health_check" {
  name               = "health-check"
  check_interval_sec = 5
  timeout_sec        = 5
  port               = 80
}

resource "google_compute_target_pool" "webserver-pool-r1" {
  name = "webserver-instance-pool-r1"
  region = "${var.region1}"

  health_checks = [
    "${google_compute_http_health_check.health_check.name}"
  ]
}

resource "google_compute_target_pool" "webserver-pool-r2" {
  name = "webserver-instance-pool-r2"
  region = "${var.region2}"

  health_checks = [
    "${google_compute_http_health_check.health_check.name}"
  ]
}

resource "google_compute_firewall" "health-checks" {
  name = "allow-health-checks"
  network = "default"
  project = "${google_project.project.project_id}"
  target_tags = ["web"]
  direction = "INGRESS"
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22"]
  
  allow {
    protocol = "tcp"
  }

}

resource "google_compute_firewall" "debug" {
  name = "debug"
  network = "default"
  project = "${google_project.project.project_id}"
  target_tags = ["web"]
  direction = "INGRESS"
  source_ranges = ["188.83.71.19"]
  
  allow {
    protocol = "tcp"
    ports = ["22","80"]
  }

}

output "external-addr" {
  value = "${google_compute_global_address.external-addr.address}"
}
