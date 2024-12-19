# Project Settings
variable "project_id" {
  description = "The GCP project ID where resources will be created"
  type        = string
}

variable "region" {
  description = "The GCP region to create resources"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

# Subnet Variables
variable "subnet_public_name" {
  description = "The name of the public subnet"
  type        = string
}

variable "subnet_private_name" {
  description = "The name of the private subnet"
  type        = string
}

variable "subnet_proxy_name" {
  description = "The name of the proxy subnet"
  type        = string
}

variable "subnet_public_cidr" {
  description = "The CIDR range for the public subnet"
  type        = string
}

variable "subnet_private_cidr" {
  description = "The CIDR range for the private subnet"
  type        = string
}

variable "subnet_proxy_cidr" {
  description = "The CIDR range for the proxy subnet"
  type        = string
}

# Proxy Subnet Purpose
variable "subnet_proxy_purpose" {
  description = "The purpose of the proxy subnet"
  type        = string
  default     = "REGIONAL_MANAGED_PROXY"
}

# Private IP Google Access
variable "enable_private_ip_google_access" {
  description = "Whether to enable Private Google Access for private and proxy subnets"
  type        = bool
  default     = true
}

# Firewall Rules
variable "firewall_rules" {
  description = "List of firewall rules to create"
  type = list(object({
    name          = string
    protocol      = string
    ports         = list(string)
    source_ranges = list(string)
  }))
  default = [
    {
      name          = "allow-health-checks"
      protocol      = "tcp"
      ports         = ["80"]
      source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
    },
    {
      name          = "allow-internal-http"
      protocol      = "tcp"
      ports         = ["80"]
      source_ranges = ["10.0.0.0/8"]
    },
    {
      name          = "allow-internal-ssh"
      protocol      = "tcp"
      ports         = ["22"]
      source_ranges = ["10.0.0.0/8"]
    },
    {
      name          = "allow-ssh"
      protocol      = "tcp"
      ports         = ["22"]
      source_ranges = ["0.0.0.0/0"]
    },
    {
      name          = "allow-vpn"
      protocol      = "tcp"
      ports         = ["1194"]
      source_ranges = ["0.0.0.0/0"]
    },
    {
      name          = "gitlab-vpc-allow-http"
      protocol      = "tcp"
      ports         = ["80"]
      source_ranges = ["0.0.0.0/0"]
    },
    {
      name          = "gitlab-vpc-allow-https"
      protocol      = "tcp"
      ports         = ["443"]
      source_ranges = ["0.0.0.0/0"]
    }
  ]
}

# Instance Template Variables
variable "instance_template_name" {
  description = "The name of the instance template"
  type        = string
  default     = "gitlab-instance-template"
}

variable "instance_machine_type" {
  description = "The machine type for the instance template"
  type        = string
}

variable "image_family" {
  description = "The image family for the instance template"
  type        = string
}

variable "image_project" {
  description = "The image project for the instance template"
  type        = string
}

# SSH Configuration for Instance Template
variable "ssh_username" {
  description = "The username for SSH access"
  type        = string
  default     = "michaln"
}

variable "ssh_public_key" {
  description = "The public SSH key for SSH access"
  type        = string
}

# Instance Group Variables
variable "instance_group_name" {
  description = "The name of the instance group"
  type        = string
}

variable "instance_group_zone" {
  description = "The zone for the instance group"
  type        = string
}

variable "instance_group_target_size" {
  description = "The desired size of the instance group"
  type        = number
}

# Static IP Variables
variable "static_ip_address" {
  description = "The private IP address for the load balancer"
  type        = string
}

# Load Balancer Variables
variable "forwarding_rule_name" {
  description = "The name of the forwarding rule"
  type        = string
}

variable "backend_service_name" {
  description = "The name of the backend service"
  type        = string
}

variable "health_check_name" {
  description = "The name of the health check"
  type        = string
}

variable "health_check_port" {
  description = "The port for the health check"
  type        = number
  default     = 80
}

variable "bastion_zone" {
  description = "The zone where the bastion host will be deployed"
  type        = string
  default     = "us-east1-b"  # Adjust this default value if needed
}