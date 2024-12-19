resource "google_compute_instance_group_manager" "this" {
  name               = var.group_name
  base_instance_name = var.base_instance_name
  zone               = var.zone
  target_size        = var.target_size

  version {
    instance_template = var.instance_template_self_link
  }
}

