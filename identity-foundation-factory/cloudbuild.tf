locals {
  oathkeeper_container_image_name = join("/", [
    "${google_artifact_registry_repository.identity_foundation_container_registry.location}-docker.pkg.dev",
    "${google_artifact_registry_repository.identity_foundation_container_registry.project}",
    "${google_artifact_registry_repository.identity_foundation_container_registry.repository_id}/oathkeeper"
  ])
  identity_foundation_account_container_image_name = join("/", [
    "${google_artifact_registry_repository.identity_foundation_container_registry.location}-docker.pkg.dev",
    "${google_artifact_registry_repository.identity_foundation_container_registry.project}",
    "${google_artifact_registry_repository.identity_foundation_container_registry.repository_id}/account"
  ])
  identity_foundation_app_container_image_name = join("/", [
    "${google_artifact_registry_repository.identity_foundation_container_registry.location}-docker.pkg.dev",
    "${google_artifact_registry_repository.identity_foundation_container_registry.project}",
    "${google_artifact_registry_repository.identity_foundation_container_registry.repository_id}/app"
  ])
}

resource "google_cloudbuild_trigger" "oathkeeper" {
  project = "${var.google_project}/locations/${var.google_region}"
  name    = "oathkeeper"
  included_files = [
    "identity-foundation-factory/**/*"
  ]
  github {
    owner = "sfeir-open-source"
    name  = "identity-infrastructure"
    push {
      branch = "main"
    }
  }
  build {
    images = [
      local.oathkeeper_container_image_name
    ]
    step {
      name = var.docker_container_image_name
      args = [
        "pull",
        var.oathkeeper_container_image_name
      ]
    }
    step {
      name = var.docker_container_image_name
      args = [
        "tag",
        var.oathkeeper_container_image_name,
        local.oathkeeper_container_image_name
      ]
    }
  }
  depends_on = [
    google_project_service.cloud_build
  ]
}

resource "google_cloudbuild_trigger" "identity_foundation_account" {
  project = "${var.google_project}/locations/${var.google_region}"
  name    = "identity-foundation-account"
  included_files = [
    "identity-foundation-account/**/*"
  ]
  github {
    owner = "sfeir-open-source"
    name  = "identity-infrastructure"
    push {
      branch = "main"
    }
  }
  build {
    images = [
      local.identity_foundation_account_container_image_name
    ]
    step {
      name = var.docker_container_image_name
      args = [
        "build",
        "-t",
        local.identity_foundation_account_container_image_name,
        "identity-foundation-account"
      ]
    }
  }
  depends_on = [
    google_project_service.cloud_build
  ]
}

resource "google_cloudbuild_trigger" "identity_foundation_app" {
  project = "${var.google_project}/locations/${var.google_region}"
  name    = "identity-foundation-app"
  included_files = [
    "identity-foundation-app/**/*"
  ]
  github {
    owner = "sfeir-open-source"
    name  = "identity-infrastructure"
    push {
      branch = "main"
    }
  }
  build {
    images = [
      local.identity_foundation_app_container_image_name
    ]
    step {
      name = var.docker_container_image_name
      args = [
        "build",
        "-t",
        local.identity_foundation_app_container_image_name,
        "identity-foundation-app"
      ]
    }
  }
  depends_on = [
    google_project_service.cloud_build
  ]
}

resource "google_cloudbuild_trigger" "identity_foundation_deployments" {
  project = "${var.google_project}/locations/${var.google_region}"
  name    = "identity-foundation-deployments"
  included_files = [
    "identity-foundation-deployments/${var.environment}/**/*"
  ]
  github {
    owner = "sfeir-open-source"
    name  = "identity-infrastructure"
    push {
      branch = "main"
    }
  }
  build {
    step {
      id   = "id-token-jwks"
      name = var.gcloud_container_image_name
      args = [
        "kms",
        "decrypt",
        "--key=${google_kms_crypto_key.sensitive.name}",
        "--keyring=${google_kms_key_ring.terraform.name}",
        "--location=${var.google_region}",
        "--plaintext-file",
        "identity-foundation-deployments/${var.environment}/infrastructure/id_token.jwks.json",
        "--ciphertext-file",
        "identity-foundation-deployments/${var.environment}/infrastructure/id_token.jwks.enc.json"
      ]
    }
    step {
      name = var.gcloud_container_image_name
      args = [
        "secrets",
        "versions",
        "add",
        google_secret_manager_secret.idtoken_jwks.name,
        "--data-file",
        "identity-foundation-deployments/${var.environment}/infrastructure/id_token.jwks.json"
      ]
    }
  }
  depends_on = [
    google_project_service.cloud_build
  ]
}

resource "google_project_iam_member" "cloudbuild_kms_crypto_key_encrypter_decrypter" {
  project = var.google_project
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_secret_manager_secret_version_adder" {
  project = var.google_project
  role    = "roles/secretmanager.secretVersionAdder"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}
