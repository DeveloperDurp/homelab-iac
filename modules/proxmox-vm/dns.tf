resource "unifi_dns_record" "control_records" {
  name        = "${var.name}.durp.loc"
  enabled     = true
  record_type = "A"
  ttl         = 300
  value       = var.ip_address
}