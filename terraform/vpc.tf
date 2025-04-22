# vpc.tf
resource "google_compute_network" "movie_vpc" {
  name    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "movie_subnet" {
  name          = var.subnet_name
  region        = var.region
  network       = google_compute_network.movie_vpc.id
  ip_cidr_range = "10.0.0.0/24"
}
