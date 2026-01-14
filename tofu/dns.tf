provider "cloudflare" {
  email     = "cloudflare@grigorjan.net"
  api_token = var.cloudflare_api_token
}

locals {
  grigorjan_net_zone_id = "031954488928102b0936fee7bd9d3312"
}

resource "cloudflare_dns_record" "abiopetaja_a" {
  type    = "A"
  name    = "abiopetaja.grigorjan.net"
  content = hcloud_server.neon.ipv4_address
  ttl     = 1
  zone_id = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "linkace_a" {
  type    = "A"
  name    = "linkace.grigorjan.net"
  content = hcloud_server.neon.ipv4_address
  ttl     = 1
  zone_id = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "siege_a" {
  type    = "A"
  name    = "siege.grigorjan.net"
  content = hcloud_server.neon.ipv4_address
  ttl     = 1
  zone_id = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "neon_a" {
  type    = "A"
  name    = "neon.grigorjan.net"
  content = hcloud_server.neon.ipv4_address
  ttl     = 1
  zone_id = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "root_website" {
  type    = "CNAME"
  name    = "grigorjan.net"
  content = "www.grigorjan.net"
  ttl     = 1
  zone_id = local.grigorjan_net_zone_id
}

resource "cloudflare_dns_record" "www_website" {
  type    = "A"
  name    = "www.grigorjan.net"
  content = hcloud_server.neon.ipv4_address
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
