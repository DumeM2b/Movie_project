# scheduler.tf
resource "google_cloud_scheduler_job" "movie_logs_job" {
  name        = "movie-logs-job"
  description = "Schedule job to trigger Cloud Function"

  schedule    = "*/5 * * * *"  # Exemple : planification quotidienne à minuit
  time_zone   = "Europe/Paris"
  http_target {
    uri    = google_cloudfunctions_function.simulate_logs.https_trigger_url
    method = "POST"
  }
}
