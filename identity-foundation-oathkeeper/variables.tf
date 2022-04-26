variable "oathkeeper_proxy_public_url" {
  type        = string
  description = "The public URL of the Oathkeeper proxy service"
  default     = "http://127.0.0.1:4455"
}

variable "identity_foundation_account_public_url" {
  type        = string
  description = "The public URL of the identity-foundation-account service"
  default     = "http://identity-foundation-account"
}

variable "identity_foundation_app_public_url" {
  type        = string
  description = "The public URL of the identity-foundation-app service"
  default     = "http://identity-foundation-app:3000"
}

variable "oathkeeper_google_url" {
  type        = string
  description = "The public URL of the Oathkeeper Google Hydrator service"
}

variable "oathkeeper_access_rules_repositories" {
  type        = list(string)
  description = "The list of repositories which contain the Oathkeeper access rules"
  default = [
    "file:///etc/ory/oathkeeper/access-rules.yaml"
  ]
}

variable "oathkeeper_google_username" {
  type        = string
  description = "The username of the Oathkeeper Google Hydrator"
}

variable "oathkeeper_google_password" {
  type        = string
  description = "The password of the Oathkeeper Google Hydrator"
}
