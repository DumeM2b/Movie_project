# Créer un service account pour le déploiement
resource "google_service_account" "movie_service_account" {
  account_id   = "movie-service-account"
  display_name = "Movie Service Account"
}

# Ajouter les droits IAM pour le service account (ex: Editor sur le projet entier)
resource "google_project_iam_member" "service_account_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.movie_service_account.email}"
}

# Use google_secret_manager_secret_iam_policy instead of google_secret_manager_secret_iam_member
data "google_iam_policy" "serviceagent_secretAccessor" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = ["serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project     = google_secret_manager_secret.github_token_secret.project
  secret_id   = google_secret_manager_secret.github_token_secret.secret_id
  policy_data = data.google_iam_policy.serviceagent_secretAccessor.policy_data
}

data "google_project" "project" {
}
