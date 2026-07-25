output "server_id" {
  description = "Hetzner Cloud server ID."
  value       = hcloud_server.hermes.id
}

output "ipv4_address" {
  description = "Public IPv4 address."
  value       = hcloud_server.hermes.ipv4_address
}

output "ssh_command" {
  description = "Command used to connect as the operator user."
  value       = "ssh hermes@${hcloud_server.hermes.ipv4_address}"
}
