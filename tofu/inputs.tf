variable "aws_access_key" {
  type = string
  sensitive = true
  description = "The AWS root access key ID"
}

variable "aws_secret_key" {
  type = string
  sensitive = true
  description = "The AWS root access key value"
}

variable "cloudflare_api_token" {
  type = string
  sensitive = true
  description = "The Cloudflare API token with permissions: DNS:Edit"
}

variable "hcloud_token" {
  type = string
  sensitive = true
  description = "The Hetzner Cloud API token for a particular project"
}
