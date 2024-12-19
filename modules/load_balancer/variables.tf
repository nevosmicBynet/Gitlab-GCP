# Health Check Variables
variable "health_check_name" {
  description = "The name of the health check"
  type        = string
}

variable "health_check_port" {
  description = "The port for the health check"
  type        = number
}

# Backend Service Variables
variable "backend_service_name" {
  description = "The name of the backend service"
  type        = string
}

variable "instance_group_self_link" {
  description = "The self-link of the instance group to be added to the backend service"
  type        = string
}

# Forwarding Rule Variables
variable "forwarding_rule_name" {
  description = "The name of the forwarding rule"
  type        = string
}

variable "subnetwork_id" {
  description = "The ID of the subnetwork for the load balancer"
  type        = string
}

variable "static_ip_address" {
  description = "The static IP address for the forwarding rule"
  type        = string
}

variable "region" {
  description = "The region for the load balancer resources"
  type        = string
}