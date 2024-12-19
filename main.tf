terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.5.0"
    }
  }

  required_version = ">= 0.13"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "vpc" {
  source       = "./modules/vpc"
  network_name = var.network_name
}

module "subnet_public" {
  source                   = "./modules/subnet"
  subnet_name              = var.subnet_public_name
  region                   = var.region
  network_id               = module.vpc.vpc_id
  cidr_range               = var.subnet_public_cidr
  private_ip_google_access = false  # Public subnet does not need private IP access
}

module "subnet_private" {
  source                   = "./modules/subnet"
  subnet_name              = var.subnet_private_name
  region                   = var.region
  network_id               = module.vpc.vpc_id
  cidr_range               = var.subnet_private_cidr
  private_ip_google_access = var.enable_private_ip_google_access
}

module "subnet_proxy" {
  source                   = "./modules/subnet"
  subnet_name              = var.subnet_proxy_name
  region                   = var.region
  network_id               = module.vpc.vpc_id
  cidr_range               = var.subnet_proxy_cidr
  private_ip_google_access = var.enable_private_ip_google_access
  purpose                  = var.subnet_proxy_purpose
  role                     = "ACTIVE" # Set role explicitly for proxy subnet
}

# Dynamically create firewall rules
module "firewall_rules" {
  for_each = { for rule in var.firewall_rules : rule.name => rule }

  source = "./modules/firewall"

  firewall_name  = each.value.name
  network_id     = module.vpc.vpc_id
  protocol       = each.value.protocol
  ports          = each.value.ports
  source_ranges  = each.value.source_ranges
}

module "compute" {
  source             = "./modules/compute"
  template_name      = var.instance_template_name
  machine_type       = var.instance_machine_type
  subnetwork_id      = module.subnet_private.subnet_id
  region             = var.region
  image_family       = var.image_family
  image_project      = var.image_project
  group_name         = var.instance_group_name
  zone               = var.instance_group_zone
  target_size        = var.instance_group_target_size
  static_ip_address  = var.static_ip_address

  # Bastion
  bastion_zone         = var.bastion_zone
  subnet_public_id     = module.subnet_public.subnet_id
  ssh_public_key       = var.ssh_public_key
  ssh_username         = var.ssh_username
}

module "load_balancer" {
  source                   = "./modules/load_balancer"

  # Health Check Variables
  health_check_name        = var.health_check_name
  health_check_port        = 80

  # Backend Service Variables
  backend_service_name     = var.backend_service_name
  instance_group_self_link = module.compute.region_instance_group_self_link

  # Forwarding Rule Variables
  forwarding_rule_name     = var.forwarding_rule_name
  subnetwork_id            = module.subnet_private.subnet_id
  static_ip_address        = module.compute.static_ip_address
  region                   = var.region
}

#module "instance_template" {
#  source           = "./modules/compute"
#  template_name    = var.instance_template_name
#  machine_type     = var.instance_machine_type
#  region           = var.region
#  image            = var.image
#  ssh_username     = var.ssh_username
#  ssh_public_key   = var.ssh_public_key
#  network_id       = module.vpc.vpc_id
#  disk_size        = var.instance_disk_size
#  disk_type        = var.instance_disk_type
#  zone             = var.instance_group_zone
#  startup_script   = var.instance_startup_script
#  target_size                  = var.instance_group_target_size
#  subnetwork_id    = module.subnet_private.subnet_id  # Private subnet
#
#}
#
#module "instance_group" {
#  source                       = "./modules/compute"
#  group_name                   = var.group_name      
#  base_instance_name           = var.base_instance_name      
#  zone                         = var.instance_group_zone
#  target_size                  = var.instance_group_target_size
#  ssh_public_key               = var.ssh_public_key
#  startup_script               = var.instance_startup_script
#  region                       = var.region
#  network_id                   = module.vpc.vpc_id
#  ssh_username                 = var.ssh_username
#  template_name                = var.instance_template_name
#  subnetwork_id    = module.subnet_private.subnet_id  # Private subnet
#}
