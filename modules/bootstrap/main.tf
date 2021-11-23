variable "billing_account" {}

variable "name" {}

variable "environment_group" {}

variable "environment" {}

variable "parent_folder_id" {}

variable "organization_id" {}

locals {
  project_name = "${var.environment_group}-${var.environment}-${var.name}"
}
module "app_project" {
  source            = "terraform-google-modules/project-factory/google"
  version           = "~> 11.2"
  org_id            = var.organization_id
  name              = local.project_name
  random_project_id = true
  billing_account   = var.billing_account
  folder_id         = var.parent_folder_id
  group_name        = "gcp-organization-admins"
  activate_apis     = [
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "storage-api.googleapis.com",
    "monitoring.googleapis.com",
    // default additions
    "firebase.googleapis.com",
  ]
}

resource "google_project_iam_member" "default_service_account_membership" {
  project  = module.app_project.project_id
  for_each = toset(["roles/firebase.admin", "roles/firebase.managementServiceAgent"])
  role     = each.key

  member = "serviceAccount:${module.app_project.service_account_email}"
}
resource "google_storage_bucket" "state" {
  name                        = "${module.app_project.project_id}-state"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = false
  project                     = module.app_project.project_id
  versioning {
    enabled = true
  }
}
resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.state.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${module.app_project.service_account_email}"
}

output "bucket_name" {
  value = google_storage_bucket.state.name
}

output "project_id" {
  value = module.app_project.project_id
}

output "service_account_id" {
  value = module.app_project.service_account_id
}

output "service_account_email" {
  value = module.app_project.service_account_email
}