variable "pm_api_url" {
  description = "API URL to Proxmox provider"
  type        = string
}

variable "dnsserver" {
  description = "DNS provider"
  type        = string
}

variable "sshkeys" {
  description = "Public SSH key to inject into CloudInit"
  type        = string
}

variable "pm_password" {
  description = "Passowrd to Proxmox provider"
  type        = string
}

variable "pm_user" {
  description = "UIsername to Proxmox provider"
  type        = string
  default     = "root@pam"
}

variable "template" {
  description = "Default Template to clone from"
  type        = string
  default     = "Debian12-Template"
}

variable "environment" {
  description = "environment"
  type        = string
}

variable "ipprefix" {
  type = number
}

variable "k3master" {
  description = "Defaults of master nodes in K3S"
  type = object({
    count   = number
    name    = list(string)
    cores   = number
    memory  = number
    drive   = string
    storage = string
    node    = list(string)
    ip      = list(number)
  })
}

variable "k3server" {
  description = "Defaults of master nodes in K3S"
  type = object({
    count   = number
    name    = list(string)
    cores   = number
    memory  = number
    drive   = string
    storage = string
    node    = list(string)
    ip      = list(number)
  })
}