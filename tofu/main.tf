terraform {
  required_version = "~>1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.8"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~>5.8"
    }
    github = {
      source  = "integrations/github"
      version = "~>6.6"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~>1.52"
    }
    neon = {
      source  = "kislerdm/neon"
      version = "~>0.9"
    }
  }
}
