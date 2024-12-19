resource "google_compute_instance_template" "this" {
  name         = var.template_name
  machine_type = var.machine_type

  disk {
    auto_delete = true
    boot        = true
    disk_size_gb = var.disk_size
    disk_type   = var.disk_type
    source_image = var.image
  }

  network_interface {
    network = var.network_id
    access_config {}
  }

  metadata = {
    startup-script = <<-EOT
      #!/bin/bash
      USER=${var.ssh_username}
      SSH_KEY="${var.ssh_public_key}"

      # Ensure the user exists
      if ! id -u $USER &>/dev/null; then
        sudo useradd -m -s /bin/bash $USER
      fi

      # Ensure the .ssh directory exists
      sudo -u $USER mkdir -p /home/$USER/.ssh
      sudo -u $USER chmod 700 /home/$USER/.ssh

      # Add the SSH key to authorized_keys
      echo "$SSH_KEY" | sudo -u $USER tee -a /home/$USER/.ssh/authorized_keys > /dev/null
      sudo -u $USER chmod 600 /home/$USER/.ssh/authorized_keys

      # Ensure proper ownership
      sudo chown -R $USER:$USER /home/$USER/.ssh

      echo "SSH key added for user $USER"
    EOT
  }
}

output "self_link" {
  description = "The self-link of the instance template"
  value       = google_compute_instance_template.this.self_link
}