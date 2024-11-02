terraform {
  required_version = "< 1.9.9"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.3"
    }
  }

  backend "gcs" {
    bucket = "<YOUR_TERRAFORM_STATE_BUCKET>"
    prefix = "terraform_infrastructure"
  }
}

resource "google_storage_bucket" "terraform_state" {
  name     = "<YOUR_TERRAFORM_STATE_BUCKET>" # todo: Replace with your Terraform state bucket name
  location = "<YOUR_REGION>" # todo: Replace with your region

  # Configured permissions per bucket, rather than for each object individually.
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"

  # Enables versioning of the Terraform state.
  # If a new state is uploaded by Terraform the old state is kept as a version.
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "atlantis" {
  name     = "<YOUR_ATLANTIS_BUCKET>" # todo: Replace with your Atlantis bucket name
  location = "<YOUR_REGION>" # todo: Replace with your region

  # Configured permissions per bucket, rather than for each object individually.
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"
}

resource "google_clouddeploy_delivery_pipeline" "atlantis" {
  location    = "<YOUR_REGION>"
  name        = "atlantis"

  serial_pipeline {
    stages {
      profiles = ["target"] # The target profile as specified in the skaffold.yaml file
      target_id = "atlantis-target"
    }
  }
}

resource "google_clouddeploy_target" "atlantis_prod" {
  location = "<YOUR_REGION>" # todo: Replace with your region
  name     = "atlantis-target"

  run {
    location = "projects/<YOUR_PROJECT>/locations/<YOUR_REGION>" # todo: Replace with your project and region
  }

  require_approval = false
}

resource "google_binary_authorization_policy" "default" {
  default_admission_rule {
    evaluation_mode  = "REQUIRE_ATTESTATION"
    enforcement_mode = "ENFORCED_BLOCK_AND_AUDIT_LOG"
    require_attestations_by = [
      "projects/<YOUR_PROJECT>/attestors/built-by-cloud-build" # todo: Replace with your project
    ]
  }
}
