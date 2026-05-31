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

resource "unifi_dns_record" "control_records" {
  count       = local.control.count
  name        = "${local.control.name[count.index]}.durp.loc"
  enabled     = true
  record_type = "A"
  ttl         = 300
  value       = local.control.ip[count.index]
}

resource "unifi_dns_record" "worker_records" {
  count       = local.worker.count
  name        = "${local.worker.name[count.index]}.durp.loc"
  record_type = "A"
  value       = local.worker.ip[count.index]
  enabled     = true
  ttl         = 300
}

resource "unifi_dns_record" "cluster_endpoint" {
  count       = local.control.count
  name        = local.talos.cluster_dns
  record_type = "A"
  value       = local.control.ip[count.index]
  enabled     = true
  ttl         = 300
}
