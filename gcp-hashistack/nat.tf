## Create Cloud Router
resource "google_compute_router" "router" {
  name    = "${var.name}-nat-router"
  project = var.project
  network = google_compute_network.vpc.name
  region  = var.region
}

## Create Nat Gateway
resource "google_compute_router_nat" "nat" {
  name   = "${var.name}-nat-gateway"
  router = google_compute_router.router.name
  region = google_compute_router.router.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [data.google_compute_address.ip_nat.self_link]

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
