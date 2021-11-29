

locals {
  project_name = "${var.group_name}-${var.environment_name}-${var.name}"
}


output "state_bucket_name" {
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