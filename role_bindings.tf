resource "google_project_iam_member" "default_service_account_membership" {
  project  = module.app_project.project_id
  for_each = toset(["roles/firebase.admin", "roles/firebase.managementServiceAgent"])
  role     = each.key

  member = "serviceAccount:${module.app_project.service_account_email}"
}
