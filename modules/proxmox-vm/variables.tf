variable "name" {
  type = string
}

variable "target_node" {
  type = string
}

variable "vmid" {
  type    = number
  default = null
}

variable "desc" {
  type    = string
  default = "Managed by OpenTofu"
}

variable "tags" {
  type = string
}

variable "cores" {
  type = number
}

variable "memory" {
  type = number
}

variable "storage" {
  type = string
}

variable "drive_size" {
  type = string
}

variable "format" {
  type    = string
  default = "raw"
}

variable "template" {
  type    = string
  default = null
}

variable "vlan" {
  type = number
}

variable "ip_address" {
  type = string
}

variable "gateway" {
  type = string
}

variable "sshkeys" {
  type    = string
  default = null
}

variable "nameserver" {
  type = string
}

variable "searchdomain" {
  type    = string
  default = "durp.loc"
}

variable "ciuser" {
  type    = string
  default = "administrator"
}