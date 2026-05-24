provider "unifi" {
  api_url        = "https://192.168.1.1/"
  api_key        = var.unifi_api_key
  allow_insecure = true
}

variable "unifi_api_key" {
  description = "api key for unifi"
  type        = string
}

resource "unifi_dns_record" "control_records" {
  count   = local.control.count
  name    = "${local.control.name[count.index]}.durp.loc"
  type    = "A"
  value   = local.control.ip[count.index]
  enabled = true
  ttl     = 300
}

resource "unifi_dns_record" "worker_records" {
  count   = local.worker.count
  name    = "${local.worker.name[count.index]}.durp.loc"
  type    = "A"
  value   = local.worker.ip[count.index]
  enabled = true
  ttl     = 300
}

resource "unifi_dns_record" "cluster_endpoint" {
  count   = local.control.count
  name    = local.talos.cluster_dns
  type    = "A"
  value   = local.control.ip[count.index]
  enabled = true
  ttl     = 300
}
