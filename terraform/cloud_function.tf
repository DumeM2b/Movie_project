resource "google_cloud_run_v2_service" "simulate_logs" {
  name     = "simulate-logs"
  location = var.region
  deletion_protection = false

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_repo.repository_id}/simulate-logs:latest"

      env {
        name  = "PUBSUB_TOPIC"
        value = "projects/${var.project_id}/topics/movie-topic"
      }
    }
  }
  depends_on = [
      google_cloudbuild_trigger.simulate_logs_build
    ]

}
