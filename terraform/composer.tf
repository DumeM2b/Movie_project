resource "google_composer_environment" "movie_composer" {
  name   = "movie-composer-env"
  region = var.region
  
  config {
    software_config {
      image_version = "composer-3-airflow-2.10.5"

      pypi_packages = {
          pandas = ""
      }

    }

    enable_private_builds_only = true

    node_config {
      network = google_compute_network.movie_vpc.id
      subnetwork = google_compute_subnetwork.movie_subnet.id
    }
}
}
