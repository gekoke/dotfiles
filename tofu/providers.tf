terraform {
  required_version = "~> 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }

    # Dependencies for `nixos-anywhere`
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.4"
    }
  }
}
