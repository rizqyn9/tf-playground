# NOMAD SERVER INSTANCES
resource "google_compute_instance" "nomad_server" {
  count        = var.nomad_server_count
  name         = "${var.name}-server-${count.index + 1}"
  machine_type = var.nomad_server_machine_type
  zone         = var.zone
  tags         = [var.tag_auto_join, "nomad-server"]

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.machine_image
      size  = var.nomad_server_disk_size
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet.name
  }

  service_account {
    # https://developers.google.com/identity/protocols/googlescopes
    scopes = [
      "https://www.googleapis.com/auth/compute.readonly",
      "https://www.googleapis.com/auth/logging.write",
    ]
  }

  metadata_startup_script = templatefile("./packer/shared/data-scripts/user-data-server.sh", {
    server_count = var.nomad_server_count
    retry_join   = var.retry_join
  })
}

# CLIENT LOAD BALANCER
resource "google_compute_instance" "nomad_client_lb" {
  count        = var.nomad_client_lb_count
  name         = "${var.name}-client-lb-${count.index + 1}"
  machine_type = var.nomad_client_lb_machine_type
  zone         = var.zone
  tags         = [var.tag_auto_join, "nomad-clients", "load-balancer"]

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.machine_image
      size  = var.nomad_client_lb_disk_size
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet.name
  }

  service_account {
    # https://developers.google.com/identity/protocols/googlescopes
    scopes = [
      "https://www.googleapis.com/auth/compute.readonly",
      "https://www.googleapis.com/auth/logging.write",
    ]
  }

  metadata_startup_script = templatefile("./packer/shared/data-scripts/user-data-client.sh", {
    region     = var.region
    retry_join = var.retry_join
  })
}

# CLIENT WORKER
resource "google_compute_instance" "nomad_client" {
  count        = var.nomad_client_worker_count
  name         = "${var.name}-client-worker-${count.index + 1}"
  machine_type = var.nomad_client_worker_machine_type
  zone         = var.zone
  tags         = [var.tag_auto_join, "nomad-clients", "worker"]

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.machine_image
      size  = var.nomad_client_worker_disk_size
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet.name
  }

  service_account {
    # https://developers.google.com/identity/protocols/googlescopes
    scopes = [
      "https://www.googleapis.com/auth/compute.readonly",
      "https://www.googleapis.com/auth/logging.write",
    ]
  }

  metadata_startup_script = templatefile("./packer/shared/data-scripts/user-data-client.sh", {
    region     = var.region
    retry_join = var.retry_join
  })
}
