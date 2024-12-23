# Output the backend service name
output "backend_service_name" {
  description = "The name of the regional backend service"
  value       = google_compute_region_backend_service.this.name
}

# Output the forwarding rule name
output "forwarding_rule_name" {
  description = "The name of the forwarding rule"
  value       = google_compute_forwarding_rule.this.name
}
output "backend_service_ip" {
  description = "The IP address of the backend service"
  value       = google_compute_forwarding_rule.this.ip_address
}