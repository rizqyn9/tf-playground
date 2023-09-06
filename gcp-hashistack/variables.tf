variable "project" {
  description = "The GCP project to use."
  type        = string
}

variable "region" {
  description = "The GCP region to deploy to."
  type        = string
}

variable "zone" {
  description = "The GCP zone to deploy to."
  type        = string
}

variable "machine_image" {
  description = "The compute image to use for the server and client machines. Output from the Packer build process."
  type        = string
}

variable "name" {
  type    = string
  default = "dev"
}

variable "ip_public_name" {
  type = string
}

variable "ip_nat_name" {
  type = string
}

variable "retry_join" {
  type        = string
  description = "project_name=<PROJECT_ID> provider=gce tag_value=<TAG_AUTO_JOIN>"
}

variable "tag_auto_join" {
  type = string
}

variable "nomad_server_count" {
  type = number
}

variable "nomad_server_machine_type" {
  type    = string
  default = "e2-small"
}

variable "nomad_server_disk_size" {
  type    = number
  default = 20
}

variable "nomad_client_lb_count" {
  type = number
}

variable "nomad_client_lb_machine_type" {
  type    = string
  default = "e2-small"
}

variable "nomad_client_lb_disk_size" {
  type    = number
  default = 20
}

variable "nomad_client_worker_count" {
  type = number
}

variable "nomad_client_worker_machine_type" {
  type    = string
  default = "e2-small"
}

variable "nomad_client_worker_disk_size" {
  type    = number
  default = 20
}

variable "host_nomad" {
  type        = string
  description = "nomad.example.com"
}

variable "host_consul" {
  type        = string
  description = "consul.example.com"
}

variable "host_default" {
  type        = string
  description = "*.example.com"
}

