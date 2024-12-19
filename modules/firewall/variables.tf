variable "firewall_name" {
  description = "The name of the firewall rule"
  type        = string
}

variable "network_id" {
  description = "The VPC network ID"
  type        = string
}

variable "protocol" {
  description = "The protocol (e.g., tcp, udp)"
  type        = string
  default     = "tcp" # Default to TCP
}

variable "ports" {
  description = "The ports to allow"
  type        = list(string)
  default     = ["80", "443"] # Default to HTTP/HTTPS
}

variable "source_ranges" {
  description = "The source IP ranges"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Default to open to all (adjust for security)
}