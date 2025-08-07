terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    neon = {
      source = "kislerdm/neon"
    }
  }
}
