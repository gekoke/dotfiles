locals {
  aws_region = "eu-north-1"
}

provider "aws" {
  region     = local.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "tofu_state" {
  bucket = "tofu-state-c5bba283-c3e5-454e-a7d7-df43e34e82f6"

  lifecycle {
    prevent_destroy = true
  }
}

terraform {
  backend "s3" {
    region  = local.aws_region
    bucket  = "tofu-state-c5bba283-c3e5-454e-a7d7-df43e34e82f6"
    key     = "tofu-state-file"
  }
}
