locals {
  aws_region             = "eu-north-1"
  tofu_state_bucket_name = "tofu-state-c5bba283-c3e5-454e-a7d7-df43e34e82f6"
}

provider "aws" {
  region     = local.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "tofu_state" {
  bucket = local.tofu_state_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

terraform {
  backend "s3" {
    region = local.aws_region
    bucket = local.tofu_state_bucket_name
    key    = "tofu-state-file"
    # Starting from OpenTofu 1.19, needs credentials to be specified using a separate backend config.
    # See the `-backend-config` section in `tofu init -help` for more.
  }
}
