terraform {
  required_providers {
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
      source = "hashicorp/null"
      version = "3.2.3"
    }
    external = {
      source = "hashicorp/external"
      version = "2.3.4"
    }
  }
}
