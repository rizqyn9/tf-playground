resource "google_compute_network" "vpc" {
  name                    = "${var.name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  ip_cidr_range = "10.0.10.0/24"
  region        = var.region
  network       = google_compute_network.vpc.name
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.20.0/24"
  region        = var.region
  network       = google_compute_network.vpc.name
}

resource "google_compute_firewall" "allow_all" {
  name          = "prod-allow-all"
  network       = google_compute_network.vpc.name
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
  }
}
