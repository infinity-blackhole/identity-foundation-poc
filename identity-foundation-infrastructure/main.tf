module "oathkeeper" {
  source                                 = "../identity-foundation-oathkeeper"
  oathkeeper_proxy_public_url            = var.oathkeeper_proxy_public_url
  identity_foundation_account_public_url = var.identity_foundation_account_public_url
  identity_foundation_app_public_url     = var.identity_foundation_app_public_url
  oathkeeper_google_username             = var.oathkeeper_google_username
  oathkeeper_google_password             = data.google_kms_secret.oathkeeper_google_secret_password.plaintext
  oathkeeper_google_url                  = var.oathkeeper_google_url
  oathkeeper_access_rules_repositories = [
    "file:///secrets/oathkeeper-access-rules/access-rules.yaml"
  ]
}
