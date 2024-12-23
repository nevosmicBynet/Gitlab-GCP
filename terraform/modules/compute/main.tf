# Fetch the image details
data "google_compute_image" "image" {
  family  = var.image_family
  project = var.image_project
}

# Instance template
resource "google_compute_instance_template" "this" {
  name         = var.template_name
  machine_type = var.machine_type
  region       = var.region

  disk {
    auto_delete  = true
    boot         = true
    source_image = data.google_compute_image.image.self_link
  }

  network_interface {
    subnetwork = var.subnetwork_id
    # No public IP
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${var.ssh_public_key}"
    startup-script = <<EOT
      #!/bin/bash
      echo "${var.ssh_public_key}" >> /home/${var.ssh_username}/.ssh/authorized_keys
      chmod 600 /home/${var.ssh_username}/.ssh/authorized_keys
    EOT
  }
}

# Regional Instance Group
resource "google_compute_region_instance_group_manager" "this" {
  name               = var.group_name
  region             = var.region
  target_size        = var.target_size
  base_instance_name = var.group_name

  version {
    instance_template = google_compute_instance_template.this.self_link
  }

  # Add the private subnet to the group
  distribution_policy_zones = [
    "${var.region}-b",
    "${var.region}-c",
  ]
}

# Static IP address
resource "google_compute_address" "this" {
  name        = "gitlab-ilb-ip"
  address     = var.static_ip_address
  subnetwork  = var.subnetwork_id
  region      = var.region
  address_type = "INTERNAL" 
}

# Bastion
resource "google_compute_instance" "bastion" {
  name         = "bynet-gitlab-bastion-host"
  machine_type = var.machine_type
  zone         = var.bastion_zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.image.self_link
      type  = "pd-ssd"
      size  = 100
    }
  }

  network_interface {
    subnetwork   = var.subnet_public_id
    access_config {
      # Public IP for Bastion VM
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${var.ssh_public_key}"
    startup-script = <<EOT
      #!/bin/bash
      set -e

      # Update system packages
      apt-get update -y
      apt-get upgrade -y

      # Install required dependencies
      apt-get install -y software-properties-common

      # Add Ansible PPA and install Ansible
      apt-add-repository --yes --update ppa:ansible/ansible
      apt-get install -y ansible

      # Add SSH public key for user
      mkdir -p /home/${var.ssh_username}/.ssh
      echo "${var.ssh_public_key}" >> /home/${var.ssh_username}/.ssh/authorized_keys
      chmod 700 /home/${var.ssh_username}/.ssh
      chmod 600 /home/${var.ssh_username}/.ssh/authorized_keys
      chown -R ${var.ssh_username}:${var.ssh_username} /home/${var.ssh_username}/.ssh
    EOT
  }
}



# Fetch the Instance Group Details
data "google_compute_region_instance_group" "backend_group" {
  name   = google_compute_region_instance_group_manager.this.name
  region = var.region
}

# Fetch the First Instance Details
data "google_compute_instance" "backend_instance" {
  name = element(
    split("/", data.google_compute_region_instance_group.backend_group.instances[0].instance),
    length(split("/", data.google_compute_region_instance_group.backend_group.instances[0].instance)) - 1
  )
  zone = element(
    split("/", data.google_compute_region_instance_group.backend_group.instances[0].instance),
    length(split("/", data.google_compute_region_instance_group.backend_group.instances[0].instance)) - 3
  )
}