provider "google" {
  credentials = base64decode(var.credentials_base64)

  project = var.project
  region  = var.region
  zone    = var.zone
}

# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.name}-vpc"
  auto_create_subnetworks = false
  project                 = var.project
}

# Create a Subnet
resource "google_compute_subnetwork" "private" {
  name          = "${var.name}-subnet-private"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.vpc.name
  region        = var.region
}

resource "google_compute_subnetwork" "public" {
  name          = "${var.name}-subnet-public"
  ip_cidr_range = "10.20.0.0/24"
  network       = google_compute_network.vpc.name
  region        = var.region
}

# Firewalls
resource "google_compute_firewall" "consul_nomad_ui_ingress" {
  name          = "${var.name}-ui-ingress"
  network       = google_compute_network.vpc.id
  source_ranges = [var.allowlist_ip]

  # Nomad
  allow {
    protocol = "tcp"
    ports    = [4646]
  }

  # Consul
  allow {
    protocol = "tcp"
    ports    = [8500]
  }
}

resource "google_compute_firewall" "ssh_ingress" {
  name          = "${var.name}-ssh-ingress"
  network       = google_compute_network.vpc.name
  source_ranges = [var.allowlist_ip]

  # SSH
  allow {
    protocol = "tcp"
    ports    = [22]
  }
}

resource "google_compute_firewall" "allow_all_internal" {
  name        = "${var.name}-allow-all-internal"
  network     = google_compute_network.vpc.name
  source_tags = ["auto-join"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}


resource "google_compute_firewall" "clients_ingress" {
  name          = "${var.name}-clients-ingress"
  network       = google_compute_network.vpc.name
  source_ranges = [var.allowlist_ip]
  target_tags   = ["nomad-clients"]

  # Add application ingress rules here
  # These rules are applied only to the client nodes

  # nginx example; replace with your application port
  allow {
    protocol = "tcp"
    ports    = [80]
  }
}
