resource "google_compute_instance_group" "hashi_dashboard" {
  name      = "${var.name}-hashi-dashboard"
  instances = google_compute_instance.nomad_server[*].self_link
  zone      = var.zone

  named_port {
    name = "nomad"
    port = "4646"
  }

  named_port {
    name = "consul"
    port = "8500"
  }
}

resource "google_compute_region_backend_service" "nomad" {
  name                  = "${var.name}-nomad-service"
  region                = var.region
  health_checks         = [google_compute_region_health_check.tcp_nomad.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTP"
  port_name             = "nomad"

  backend {
    group           = google_compute_instance_group.hashi_dashboard.id
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1
  }
}

resource "google_compute_region_backend_service" "consul" {
  name                  = "prod-consul-service"
  region                = var.region
  health_checks         = [google_compute_region_health_check.tcp_nomad.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTP"
  port_name             = "consul"

  backend {
    group           = google_compute_instance_group.hashi_dashboard.id
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1
  }
}

resource "google_compute_region_health_check" "tcp_nomad" {
  name   = "${var.name}-tcp-nomad"
  region = var.region

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = 4646
  }
}
