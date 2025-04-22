# pubsub.tf
resource "google_pubsub_topic" "movie_topic" {
  name = "movie-logs-topic"
}

resource "google_pubsub_subscription" "movie_subscription" {
  name  = "movie-logs-subscription"
  topic = google_pubsub_topic.movie_topic.id
}
