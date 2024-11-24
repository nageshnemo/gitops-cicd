resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = "my-python-app-repo"
  description   = "Docker repository for storing application images"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true # Prevents overwriting tags
  }

  labels = {
    environment = "ci-cd"
    application = "python-app"
  }
}

