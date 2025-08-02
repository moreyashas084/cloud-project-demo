resource "google_dns_managed_zone" "durva_zone" {
  name     = "durva-zone"
  dns_name = "durva.dev.com."
  description = "Managed zone for durva.dev.com"
}

resource "google_dns_record_set" "durva_www" {
  name         = "www.durva.dev.com."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.durva_zone.name
  rrdatas      = ["34.49.90.86"]
}