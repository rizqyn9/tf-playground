data "google_compute_address" "ip_public" {
  name   = var.ip_public_name
  region = var.region
}

data "google_compute_address" "ip_nat" {
  name   = var.ip_nat_name
  region = var.region
}
