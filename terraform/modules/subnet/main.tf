resource "google_compute_subnetwork" "this" {
  name          = var.subnet_name
  region        = var.region
  network       = var.network_id
  ip_cidr_range = var.cidr_range

  # Set private IP Google Access only if purpose is not REGIONAL_MANAGED_PROXY
  private_ip_google_access = var.purpose == "REGIONAL_MANAGED_PROXY" ? null : var.private_ip_google_access

  # Set purpose explicitly only when provided
  purpose = var.purpose != null ? var.purpose : null

  # Set role only when purpose is REGIONAL_MANAGED_PROXY
  role = var.purpose == "REGIONAL_MANAGED_PROXY" ? var.role : null
}

output "subnet_id" {
  value = google_compute_subnetwork.this.id
}