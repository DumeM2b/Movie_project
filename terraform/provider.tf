# provider.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.31.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.31.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
