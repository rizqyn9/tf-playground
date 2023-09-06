resource "google_compute_region_url_map" "load_balancer" {
  name            = "${var.name}-load-balancer"
  region          = var.region
  default_service = google_compute_region_backend_service.web_server.id

  host_rule {
    hosts        = [var.host_consul]
    path_matcher = "consul"
  }

  host_rule {
    hosts        = [var.host_nomad]
    path_matcher = "nomad"
  }

  path_matcher {
    name            = "consul"
    default_service = google_compute_region_backend_service.consul.id
  }

  path_matcher {
    name            = "nomad"
    default_service = google_compute_region_backend_service.nomad.id
  }
}
