
output "public-ip-1" {
  description = "Reserved public IP"
  value       = google_compute_address.static_ip.address
}

output "lb_address_consul_nomad" {
  value = "http://${google_compute_instance.server[0].network_interface.0.access_config.0.nat_ip}"
}

output "consul_bootstrap_token_secret" {
  value = var.nomad_consul_token_secret
}

output "client" {
  value = join(", ", google_compute_instance.client[*].network_interface[0].network_ip)
}

output "IP_Addresses" {
  value = <<CONFIGURATION

Client public IPs: ${join(", ", google_compute_instance.client[*].name)}

Server public IPs: ${join(", ", google_compute_instance.server[*].network_interface.0.access_config.0.nat_ip)}

The Consul UI can be accessed at http://${google_compute_instance.server[0].network_interface.0.access_config.0.nat_ip}:8500/ui
with the bootstrap token: ${var.nomad_consul_token_secret}
CONFIGURATION
}

