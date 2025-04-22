# bq.tf
resource "google_bigquery_dataset" "movie_dataset" {
  dataset_id = var.bq_dataset_name
  project    = var.project_id
  location   = "EU"
}

resource "google_bigquery_table" "movie_log" {
  dataset_id = google_bigquery_dataset.movie_dataset.dataset_id
  table_id   = "log_movie"

  schema = jsonencode([
    {
      "name" = "user_id"
      "type" = "INT64"
    },
    {
      "name" = "video_id"
      "type" = "INT64"
    },
    {
      "name" = "watch_time"
      "type" = "INT64"
    },
    {
      "name" = "device"
      "type" = "STRING"
    },
    {
      "name" = "location"
      "type" = "STRING"
    },
    {
      "name" = "timestamp"
      "type" = "TIMESTAMP"
    }
  ])
}

resource "google_bigquery_table" "movie_metadata" {
  dataset_id = google_bigquery_dataset.movie_dataset.dataset_id
  table_id   = "metadata_movie"
}