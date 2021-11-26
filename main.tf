variable "billing_account" {}

variable "name" {}

variable "environment_group" {}

variable "environment" {}

variable "parent_folder_id" {}

variable "organization_id" {}

locals {
  project_name = "${var.environment_group}-${var.environment}-${var.name}"
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