resource "unifi_dns_record" "cluster_vip_dns" {
  name        = local.talos.cluster_dns
  record_type = "A"
  value       = local.talos.cluster_vip
  enabled     = true
  ttl         = 300
}
