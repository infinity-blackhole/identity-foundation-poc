locals {
  oathkeeper_google_username = "oathkeeper"
  oathkeeper_google_password = random_password.oathkeeper_google.result
}

module "oathkeeper" {
  source                                 = "../identity-foundation-oathkeeper"
  oathkeeper_proxy_public_url            = var.oathkeeper_proxy_public_url
  identity_foundation_account_public_url = var.identity_foundation_account_public_url
  identity_foundation_app_public_url     = var.identity_foundation_app_public_url
  oathkeeper_google_username             = local.oathkeeper_google_username
  oathkeeper_google_password             = local.oathkeeper_google_password
  oathkeeper_google_url                  = var.oathkeeper_google_url
  oathkeeper_access_rules_repositories = [
    "file:///secrets/oathkeeper-access-rules/access-rules.yaml"
  ]
}

resource "random_password" "oathkeeper_google" {
  length = 60
}
