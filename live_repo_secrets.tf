
locals {
  secrets = tomap({
    "state_bucket_name" : google_storage_bucket.state.name,
    "organization_id" : var.organization_id,
    "billing_account" : var.billing_account,
    "service_account_id" : module.app_project.service_account_id,
    "service_account_email" : module.app_project.service_account_email,
    "project_id" : module.app_project.project_id,
    "name" : var.name,
  })
}

resource "github_actions_secret" "bucket_name" {
  repository      = github_repository.live_environment_group.name
  for_each        = local.secrets
  secret_name     = each.key
  plaintext_value = each.value
}


