locals {
  timestamp     = regex_replace(timestamp(), "[- TZ:]", "")
  source_image  = "ubuntu-2204-jammy-v20230829"
}

variable "project" {
  type = string
}

variable "zone" {
  type = string
}

source "googlecompute" "hashistack" {
  image_name   = "rdev-hashistack-${local.timestamp}"
  project_id   = var.project
  source_image = local.source_image
  ssh_username = "packer"
  zone         = var.zone
}

build {
  sources = ["sources.googlecompute.hashistack"]

  provisioner "shell" {
    inline = ["sudo mkdir -p /ops/shared", "sudo chmod 777 -R /ops"]
  }

  provisioner "file" {
    destination = "/ops"
    source      = "./shared"
  }

  provisioner "shell" {
    script           = "./shared/scripts/setup.sh"
  }
}