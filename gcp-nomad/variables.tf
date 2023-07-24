variable "project" {
  description = "The GCP project to use."
}

variable "region" {
  description = "The GCP region to deploy to."
}

variable "zone" {
  description = "The GCP zone to deploy to."
}

variable "name" {
  description = "Prefix used to name various infrastructure components. Alphanumeric characters only."
  default     = "lab"
}

variable "machine_image" {
  description = "The compute image to use for the server and client machines. Output from the Packer build process."
}

variable "retry_join" {
  description = "Used by Consul to automatically form a cluster."
  type        = string
}

variable "credentials_base64" {
  description = "GCP base64 credentials"
}
