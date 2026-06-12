provider "unifi" {
  api_url        = var.unifi_api_url
  api_key        = var.unifi_api_key
  allow_insecure = true
}

variable "unifi_api_url" {
  description = "api key for unifi"
  type        = string
}

variable "unifi_api_key" {
  description = "api key for unifi"
  type        = string
}
resource "unifi_dns_record" "unraid_dev" {
  name        = "unraid.dev.durp.loc"
  record_type = "A"
  value       = "192.168.10.200"
  enabled     = true
  ttl         = 300
}
