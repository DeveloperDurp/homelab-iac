variable "cluster_name" {
  type        = string
  description = "Name of the Talos cluster"
}

variable "cluster_endpoint" {
  type        = string
  description = "The endpoint for the Talos cluster (e.g. https://talos.example.com:6443)"
}

variable "control_plane_ips" {
  type        = list(string)
  description = "List of IP addresses for control plane nodes"
}

variable "worker_ips" {
  type        = list(string)
  description = "List of IP addresses for worker nodes"
}

variable "allow_scheduling_on_control_planes" {
  type        = bool
  default     = false
}

variable "gitlab_repo_id" {
  type        = string
  description = "Repo ID of the gitlab project to upload variables"
}

variable "cluster_vip" {
  type        = string
  description = "Virtual IP for the Talos cluster control plane"
}
