resource "google_compute_instance_group" "web_server" {
  name = "${var.name}-web-server"
  zone = var.zone

  instances = concat(
    google_compute_instance.nomad_client_lb[*].self_link,
  )

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "https"
    port = "443"
  }
}

resource "google_compute_region_backend_service" "web_server" {
  name                  = "${var.name}-webserver"
  region                = var.region
  health_checks         = [google_compute_region_health_check.web_server.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTP"
  port_name             = "http"

  backend {
    group           = google_compute_instance_group.web_server.id
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1
  }
}

resource "google_compute_region_health_check" "web_server" {
  name   = "${var.name}-health-web-server"
  region = var.region

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = 80
  }
}
