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