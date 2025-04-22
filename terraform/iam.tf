# iam.tf
resource "google_service_account" "movie_service_account" {
  account_id   = "movie-service-account"
  display_name = "Movie Service Account"
}

resource "google_project_iam_member" "service_account_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.movie_service_account.email}"
}
