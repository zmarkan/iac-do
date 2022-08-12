terraform {

  required_version = ">= 1.1.0"

  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    local = {
      source = "hashicorp/local"
    }
  }

  cloud {
    organization = "zmarkan-demos"
    workspaces {
      name = "iac-do"
    }
  }
}

provider "kubernetes" {
  load_config_file = false
}

provider "digitalocean" {
    token = var.do_token
}