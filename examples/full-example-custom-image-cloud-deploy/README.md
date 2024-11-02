# Custom Docker Image, deployment via Cloud Deploy, and binary authorization

This example assumes that you use GitHub as your source code repository, but it can be adjusted for other VCS systems.

## Features
- Defines a Cloud Storage bucket as storage volume mount for Atlantis to store repositories, locks, and other data
- Custom Docker image with TFLint installed
- Deployment via Cloud Deploy
- Enforcement of deployments via CI pipeline by using binary authorization

## Prerequisites

- A Google Cloud project
- The [Google Cloud SDK](https://cloud.google.com/sdk)
- [Terraform](https://www.terraform.io/downloads.html)
- A GitHub repository

## Setup

1. Replace the placeholders `<YOUR_...>` in the various files.
2. Add secrets in necessary secrets in Secret Manager used in the `service.yaml` file.
3. Set up the infrastructure by running: `terraform apply`.
4. Deploy your first Atlantis instance by running: `gcloud builds submit --config cloudbuild-atlantis.yaml`.

## Explanation

This examples contains the following files:

- The `atlantis.yaml` that defines the Atlantis configuration.
- The `service.yaml` that defines the Cloud Run service and configures Cloud Storage as the storage volume mount.
- The `skaffold.yaml` that describes for Cloud Deploy how to deploy the image to Cloud Run.
- The `Dockerfile` that defines the custom Docker image, installs TFLint and copies the Atlantis configuration into the build image.
- A Cloud Build configuration file (`cloudbuild.yaml`) that builds the Docker image, pushes it to Artifact Registry, and deploys the image to Cloud Run.
- The `main.tf` that describes the resources that need to be present for the various features (like Cloud Run persistent storage, Cloud Deploy and Binary Authorization to work).
