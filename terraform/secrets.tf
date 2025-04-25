resource "google_secret_manager_secret" "github_token_secret" {
  project   = var.project_id
  secret_id = "github-token"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "github_token_secret_version" {
  secret      = google_secret_manager_secret.github_token_secret.id
  secret_data = var.github_token
}
