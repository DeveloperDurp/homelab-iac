provider "pihole" {
  url      = "http://192.168.12.41"
  password = var.pihole_password
}

variable "pihole_password" {
  description = "Password for Pihole"
  type        = string
}

resource "pihole_dns_record" "control_records" {
  count  = local.control.count
  domain = "${local.control.name[count.index]}.durp.loc"
  ip     = local.control.ip[count.index]
}

resource "pihole_dns_record" "worker_records" {
  count  = local.worker.count
  domain = "${local.worker.name[count.index]}.durp.loc"
  ip     = local.worker.ip[count.index]
}

resource "pihole_dns_record" "cluster_endpoint" {
  count  = local.control.count
  domain = local.talos.cluster_dns
  ip     = local.control.ip[count.index]
}
