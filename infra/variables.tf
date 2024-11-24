variable "project_id" {
  description = "The project ID where resources will be created"
  type        = string
}

variable "region" {
  description = "The region where resources will be created"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the primary subnet"
  type        = string
}

variable "ip_range_pods" {
  description = "The name of the secondary subnet IP range for Pods"
  type        = string
}

variable "ip_range_services" {
  description = "The name of the secondary subnet IP range for Services"
  type        = string
}

variable "gke_cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}
