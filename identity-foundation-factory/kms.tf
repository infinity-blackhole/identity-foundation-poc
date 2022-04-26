resource "google_kms_key_ring" "terraform" {
  project  = var.google_project
  name     = "terraform"
  location = var.google_region
}

resource "google_kms_crypto_key" "sensitive" {
  name     = "sensitive"
  key_ring = google_kms_key_ring.terraform.id
  purpose  = "ENCRYPT_DECRYPT"
}
