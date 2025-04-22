resource "google_cloudfunctions_function" "simulate_logs" {
  name        = "simulate-logs-function"
  description = "Simule les logs de movie"
  
  runtime = "python311"
  entry_point = "main"

  source_archive_bucket = google_storage_bucket.cloud_function_code_bucket.name
  source_archive_object = "cloud_functions/"  

  available_memory_mb = 256
  timeout             = 60

  environment_variables = {
    PUBSUB_TOPIC = google_pubsub_topic.movie_topic.id
  }
}
