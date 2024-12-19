resource "google_compute_firewall" "this" {
  name    = var.firewall_name
  network = var.network_id

  allow {
    protocol = var.protocol
    ports    = var.ports
  }

  direction   = "INGRESS"
  priority    = 1000
  source_ranges = var.source_ranges
}