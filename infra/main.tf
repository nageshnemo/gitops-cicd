
# VPC Network
resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
}

# Subnetwork with secondary IP ranges
resource "google_compute_subnetwork" "vpc_subnet" {
  name          = var.subnet_name
  ip_cidr_range = "10.0.0.0/16" # Adjust as per your needs
  region        = var.region
  network       = google_compute_network.vpc_network.id

  secondary_ip_range {
    range_name    = var.ip_range_pods
    ip_cidr_range = "10.1.0.0/20" # Secondary range for Pods
  }

  secondary_ip_range {
    range_name    = var.ip_range_services
    ip_cidr_range = "10.2.0.0/20" # Secondary range for Services
  }
}

# GKE Cluster
module "gke_cluster" {
  source              = "terraform-google-modules/kubernetes-engine/google"
  project_id          = var.project_id
  name                = var.gke_cluster_name
  network             = google_compute_network.vpc_network.name
  subnetwork          = google_compute_subnetwork.vpc_subnet.name
  ip_range_pods       = var.ip_range_pods
  ip_range_services   = var.ip_range_services

  node_pools = [{
    name           = "default-node-pool"
    machine_type   = "e2-medium"
    min_count      = 1
    max_count      = 3
    disk_size_gb   = 100
    disk_type      = "pd-standard"
    auto_repair    = true
    auto_upgrade   = true
    preemptible    = false
  }]
}
