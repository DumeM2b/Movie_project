resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = "movie-docker-repo"
  description   = "Docker repo for Cloud Run images"
  format        = "DOCKER"
}
