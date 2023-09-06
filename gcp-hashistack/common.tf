terraform {
  backend "gcs" {
    bucket = "my-lab-tf"
    prefix = "my-lab"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.20.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.80.0"
    }
  }
}

provider "google" {
  project = var.project
}
