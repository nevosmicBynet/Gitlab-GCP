variable "subnet_name" {
  description = "The name of the subnetwork"
  type        = string
}

variable "region" {
  description = "The region to create the subnetwork"
  type        = string
}

variable "network_id" {
  description = "The VPC network ID"
  type        = string
}

variable "cidr_range" {
  description = "The CIDR range for the subnetwork"
  type        = string
}

variable "private_ip_google_access" {
  description = "Whether to enable private IP Google access"
  type        = bool
  default     = false
}

variable "role" {
  description = "Role for the subnet when purpose is REGIONAL_MANAGED_PROXY (ACTIVE or BACKUP)"
  type        = string
  default     = "ACTIVE"
}

variable "purpose" {
  description = "Purpose of the subnet (e.g., REGIONAL_MANAGED_PROXY)"
  type        = string
  default     = null
}