output "subnet_public_id" {
  value = module.subnet_public.subnet_id
}

output "subnet_private_id" {
  value = module.subnet_private.subnet_id
}

output "subnet_proxy_id" {
  value = module.subnet_proxy.subnet_id
}

output "firewall_rule_names" {
  description = "The names of all created firewall rules"
  value       = [for rule in module.firewall_rules : rule.firewall_name]
}

output "backend_service" {
  description = "The name of the backend service"
  value       = module.load_balancer.backend_service_name
}

output "forwarding_rule" {
  description = "The name of the forwarding rule"
  value       = module.load_balancer.forwarding_rule_name
}