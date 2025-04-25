# dataflow.tf
resource "google_dataflow_flex_template_job" "pubsub_to_bq" {
  provider = google-beta
  name              = "pubsub-to-bq-job"
  region            = var.region
  container_spec_gcs_path = "gs://dataflow-templates-${var.region}/latest/flex/PubSub_to_BigQuery_Flex"
  parameters = {
    inputTopic        = "projects/movieproject-457013/topics/movie-logs-topic"
    outputTableSpec       = "${var.project_id}:${var.bq_dataset_name}.log_movie"
    useStorageWriteApi = "false"
    useStorageWriteApiAtLeastOnce = "false"
    numStorageWriteApiStreams = "0"
  
  }

  temp_location = "gs://${var.project_id}-temp-location/temp/"
  service_account_email = google_service_account.movie_service_account.email
  skip_wait_on_job_termination = true
}
