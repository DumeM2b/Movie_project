resource "google_cloudbuildv2_connection" "github_connection" {
  name     = "github-connection"
  location = var.region

  github_config {
    app_installation_id = var.github_installation_id
    authorizer_credential {
      oauth_token_secret_version = google_secret_manager_secret_version.github_token_secret_version.id
    }
  }
  depends_on = [google_secret_manager_secret_iam_policy.policy]
}

resource "google_cloudbuildv2_repository" "simulate_logs_repo" {
  name             = "simulate-logs"
  parent_connection = google_cloudbuildv2_connection.github_connection.id
  remote_uri       = "https://github.com/${var.github_owner}/${var.github_repo}.git"
}
