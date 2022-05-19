locals {
  project_name = "devdx"
}

variable "region" {
  type = string
}

variable "default_ec2_profile_id" {
  type = string
}

variable "tailscale_authkey" {
  type = string
}

variable "developer_pubkey" {
  type = string
}
