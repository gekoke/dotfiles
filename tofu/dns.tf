provider "cloudflare" {
  email     = "cloudflare@grigorjan.net"
  api_token = var.cloudflare_api_token
}

locals {
  grigorjan_net_zone_id = "031954488928102b0936fee7bd9d3312"
}

resource "cloudflare_dns_record" "root_website" {
  type    = "CNAME"
  name    = "grigorjan.net"
  content = "gekoke.github.io"
  ttl     = 1
  zone_id = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "www_website" {
  type    = "CNAME"
  name    = "www.grigorjan.net"
  content = "gekoke.github.io"
  ttl     = 1
  zone_id = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "github_pages_challenge" {
  type    = "TXT"
  name    = "_github-pages-challenge-gekoke.grigorjan.net"
  content = "\"58f1b8d27a8c74074eee8d2296fe9b\""
  ttl     = 1
  zone_id = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "dkim_1" {
  type    = "CNAME"
  name    = "fm1._domainkey.grigorjan.net"
  content = "fm1.grigorjan.net.dkim.fmhosted.com"
  ttl     = 1
  zone_id = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "dkim_2" {
  type    = "CNAME"
  name    = "fm2._domainkey.grigorjan.net"
  content = "fm2.grigorjan.net.dkim.fmhosted.com"
  ttl     = 1
  zone_id = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "dkim_3" {
  type    = "CNAME"
  name    = "fm3._domainkey.grigorjan.net"
  content = "fm3.grigorjan.net.dkim.fmhosted.com"
  ttl     = 1
  zone_id = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "smtp_10" {
  type     = "MX"
  name     = "grigorjan.net"
  content  = "in1-smtp.messagingengine.com"
  priority = 10
  ttl      = 1
  zone_id  = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "smpt_20" {
  type     = "MX"
  name     = "grigorjan.net"
  content  = "in2-smtp.messagingengine.com"
  priority = 20
  ttl      = 1
  zone_id  = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "dmarc" {
  type    = "TXT"
  name    = "_dmarc.grigorjan.net"
  content = "\"v=DMARC1; p=quarantine; rua=mailto:feedback@grigorjan.net; ruf=mailto:abuse@grigorjan.net\""
  ttl     = 1
  zone_id = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "spf" {
  type    = "TXT"
  name    = "grigorjan.net"
  content = "\"v=spf1 include:spf.messagingengine.com ?all\""
  ttl     = 1
  zone_id = local.grigorjan_net_zone_id
}
