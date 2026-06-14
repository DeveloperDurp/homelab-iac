variable "pm_api_url" {
  description = "API URL to Proxmox provider"
  type        = string
}

variable "pm_password" {
  description = "Passowrd to Proxmox provider"
  type        = string
}

variable "pm_user" {
  description = "UIsername to Proxmox provider"
  type        = string
}


provider "gitlab" {
  token    = var.gitlab_token
  base_url = var.gitlab_api_url
}

variable "gitlab_api_url" {
  description = "Gitlab API Url"
  type        = string
}

variable "gitlab_token" {
  description = "Gitlab Token"
  type        = string
}
