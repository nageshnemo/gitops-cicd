output "gke_cluster_name" {
  value = module.gke.name
}

output "gke_endpoint" {
  value = module.gke.endpoint
}
output "artifact_registry_repo_url" {
  description = "Docker Artifact Registry URL"
  value       = "https://${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_repo.repository_id}"
}