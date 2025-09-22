terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    github = {
      source = "integrations/github"
    }
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    neon = {
      source = "kislerdm/neon"
    }
  }
}
