variable "project_id" {}

resource "google_firebase_project" "default" {
  provider   = google-beta
  project    = var.project_id
}
