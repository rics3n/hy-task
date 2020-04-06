output "master_version" {
  value = google_container_cluster.cluster.master_version
}

output "endpoint" {
  value     = google_container_cluster.cluster.endpoint
}

#####################################################################
# Output for K8S
#####################################################################
output "client_certificate" {
  value     = google_container_cluster.cluster.master_auth.0.client_certificate
  sensitive = true
}

output "client_key" {
  value     = google_container_cluster.cluster.master_auth.0.client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = google_container_cluster.cluster.master_auth.0.cluster_ca_certificate
  sensitive = true
}

