resource "google_composer_environment" "movie_composer" {
  name   = "movie-composer-env"
  region = var.region
  
  config {
    node_count = 3
    software_config {
      image_version = "composer-3.0.0-airflow-2.5.1"  # Version de Composer 3
    }
    private_environment_config {
      enable_private_endpoint = true
      network = google_compute_network.movie_vpc.id
      subnetwork = google_compute_subnetwork.movie_subnet.id
    }

    # Indiquer le bucket contenant les DAGs
    dag_gcs_prefix = google_storage_bucket.dag_bucket.name
  }

  lifecycle {
    prevent_destroy = true
  }
}
