variable "google_project" {
  type        = string
  description = "The Google Cloud project ID"
}

variable "google_region" {
  type        = string
  description = "The Google Cloud region"
}

variable "oathkeeper_container_image_name" {
  type        = string
  description = "The Oathkeeper container image name"
  default     = "docker.io/oryd/oathkeeper@sha256:44d22a42c24ba77cea84ea1523616781d4461284b2f2f8adf6a5602a0aecd3fc"
}

variable "docker_container_image_name" {
  type        = string
  description = "The Docker container image name"
  default     = "gcr.io/cloud-builders/docker@sha256:f42c653aeae55fea4cd318a9443823c77243929dae6bb784b9eef21e1ab40d09"
}

variable "gcloud_container_image_name" {
  type        = string
  description = "The gcloud container image name"
  default     = "gcr.io/cloud-builders/gcloud@sha256:7a300ff78b2d63b0126567750922bf3ca245415ee80e563202f870e71305715d"
}

variable "environment" {
  type        = string
  description = "The environment"
}
