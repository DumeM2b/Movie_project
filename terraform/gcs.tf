resource "google_storage_bucket" "dag_bucket" {
  name          = "${var.project_id}-composer-dags"
  location      = var.region
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "cloud_function_code_bucket" {
  name          = "${var.project_id}-function-code"
  location      = var.region
  force_destroy = true
  uniform_bucket_level_access = true
}