output "instance_template_self_link" {
  description = "The self-link of the instance template"
  value       = google_compute_instance_template.this.self_link
}

output "instance_group_name" {
  description = "The name of the instance group"
  value       = google_compute_region_instance_group_manager.this.name
}

output "region_instance_group_self_link" {
  description = "The self-link of the regional instance group"
  value       = google_compute_region_instance_group_manager.this.instance_group
}

output "static_ip_address" {
  description = "The static IP address for the load balancer"
  value       = google_compute_address.this.address
}