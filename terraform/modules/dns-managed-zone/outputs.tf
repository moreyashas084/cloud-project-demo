output "managed_zone_id" {
  description = "The ID of the managed zone"
  value       = google_dns_managed_zone.main.id
}

output "managed_zone_name" {
  description = "The name of the managed zone"
  value       = google_dns_managed_zone.main.name
}

output "name_servers" {
  description = "The list of name servers for the managed zone"
  value       = google_dns_managed_zone.main.name_servers
}

output "dns_name" {
  description = "The DNS name of the managed zone"
  value       = google_dns_managed_zone.main.dns_name
}

