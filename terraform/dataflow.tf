resource "google_dataflow_job" "pubsub_to_bq" {
  name   = "pubsub-to-bq-job"
  region = var.region

  template_gcs_path = "gs://dataflow-templates-us-central1/latest/flex/PubSub_to_BigQuery_Flex"

  parameters = {
    inputTopic        = "projects/${var.project_id}/topics/log_movie"
    outputTable       = "${var.project_id}:${var.bq_dataset_name}.log_movie"
    createDisposition = "CREATE_IF_NEEDED"   
    writeDisposition  = "WRITE_APPEND"       
  }

  on_delete = "cancel"
  service_account_email = google_service_account.movie_service_account.email
}
