# Health check
resource "google_compute_health_check" "this" {
  name               = var.health_check_name
  tcp_health_check {
    port = var.health_check_port
  }
}

# Backend Service
resource "google_compute_region_backend_service" "this" {
  name                  = var.backend_service_name
  protocol              = "TCP"
  load_balancing_scheme = "INTERNAL"
  region                = var.region
  health_checks         = [google_compute_health_check.this.self_link]

  backend {
    group = var.instance_group_self_link
    balancing_mode = "CONNECTION"
  }
}

# Forwarding Rule
resource "google_compute_forwarding_rule" "this" {
  name                  = var.forwarding_rule_name
  load_balancing_scheme = "INTERNAL"
  region                = var.region
  backend_service       = google_compute_region_backend_service.this.self_link
  subnetwork            = var.subnetwork_id
  ip_address            = var.static_ip_address
  ports                 = ["80"]
}

## Health check
#resource "google_compute_health_check" "this" {
#  name               = var.health_check_name
#  check_interval_sec = 10
#  timeout_sec        = 5
#  tcp_health_check {
#    port = var.health_check_port
#  }
#}
#
## Backend Service
#resource "google_compute_region_backend_service" "this" {
#  name                  = var.backend_service_name
#  region                = var.region
#  load_balancing_scheme = "INTERNAL_MANAGED"
#  protocol              = "TCP"
#  health_checks         = [google_compute_health_check.this.self_link]
#
#  backend {
#    group = google_compute_region_instance_group_manager.this.instance_group
#  }
#}
#
## Forwarding Rule
#resource "google_compute_forwarding_rule" "this" {
#  name                  = var.forwarding_rule_name
#  load_balancing_scheme = "INTERNAL"
#  backend_service       = google_compute_region_backend_service.this.self_link
#  subnetwork            = var.subnetwork_id
#  ip_address            = var.static_ip_address
#  ip_protocol           = "TCP"
#  ports                 = ["80"]
#  region                = var.region
#}