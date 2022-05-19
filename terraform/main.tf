terraform {
  cloud {
    organization = "sora-corporation"

    workspaces {
      name = "remote-dx"
    }
  }

  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "shared" {
  source = "./modules/shared"
}

module "dev" {
  source                 = "./modules/dev"
  region                 = var.region
  default_ec2_profile_id = module.shared.default_ec2_profile_id
  tailscale_authkey      = var.tailscale_authkey
  developer_pubkey       = var.developer_pubkey
}
