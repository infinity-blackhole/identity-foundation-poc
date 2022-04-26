resource "google_project_iam_member" "runner_iam_service_account_token_creator" {
  project = var.google_project
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.runner.email}"
}
