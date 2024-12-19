# Instance Template Variables
variable "template_name" {
  description = "The name of the instance template"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the instance template"
  type        = string
}

variable "subnetwork_id" {
  description = "The ID of the subnetwork"
  type        = string
}

variable "region" {
  description = "The region for the instance template"
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

# Instance Group Variables
variable "group_name" {
  description = "The name of the instance group"
  type        = string
}

variable "zone" {
  description = "The zone for the instance group"
  type        = string
}

variable "target_size" {
  description = "The target size of the instance group"
  type        = number
}

# Static IP Variables
variable "static_ip_address" {
  description = "The private IP address for the load balancer"
  type        = string
}

# Bastion 
variable "bastion_zone" {
  description = "The zone for the bastion host"
  type        = string
}

variable "subnet_public_id" {
  description = "The ID of the public subnet"
  type        = string
}

variable "ssh_public_key" {
  description = "Path to the SSH public key for the bastion host"
  type        = string
}

variable "ssh_username" {
  description = "The username for SSH access"
  type        = string
  default     = "michaln"
}

#variable "bastion_ssh_key" {
#  description = "Path to the SSH private key for the bastion host"
#  type        = string
#}