resource "google_compute_instance" "server" {
  count        = var.server_count
  name         = "${var.name}-server-${count.index}"
  machine_type = var.server_instance_type
  zone         = var.zone
  tags         = ["auto-join"]

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.machine_image
      size  = var.root_block_device_size
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public.name

    access_config {
      // Leave empty to get an ephemeral public IP
    }
  }

  service_account {
    # https://developers.google.com/identity/protocols/googlescopes
    scopes = [
      "https://www.googleapis.com/auth/compute.readonly",
      "https://www.googleapis.com/auth/logging.write",
    ]
  }

  metadata_startup_script = templatefile("./scripts/data-scripts/user-data-server.sh", {
    server_count              = var.server_count
    region                    = var.region
    cloud_env                 = "gce"
    retry_join                = var.retry_join
    nomad_binary              = var.nomad_binary
    nomad_consul_token_id     = var.nomad_consul_token_id
    nomad_consul_token_secret = var.nomad_consul_token_secret
  })
}


resource "google_compute_instance" "client" {
  count        = var.client_count
  name         = "${var.name}-client-${count.index}"
  machine_type = var.client_instance_type
  zone         = var.zone
  tags         = ["auto-join", "nomad-clients"]

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.machine_image
      size  = var.root_block_device_size
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.private.name
  }

  service_account {
    # https://developers.google.com/identity/protocols/googlescopes
    scopes = [
      "https://www.googleapis.com/auth/compute.readonly",
      "https://www.googleapis.com/auth/logging.write",
    ]
  }

  metadata_startup_script = templatefile("./scripts/data-scripts/user-data-client.sh", {
    region                    = var.region
    cloud_env                 = "gce"
    retry_join                = var.retry_join
    nomad_binary              = var.nomad_binary
    nomad_consul_token_secret = var.nomad_consul_token_secret
  })
}
