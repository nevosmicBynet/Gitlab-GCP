resource "google_compute_network" "this" {
  name                    = var.network_name
  auto_create_subnetworks  = false
}

output "vpc_id" {
  value = google_compute_network.this.id
}