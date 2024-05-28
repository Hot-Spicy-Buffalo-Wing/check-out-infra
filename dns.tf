locals {
  domains = toset([
    "check-out",
    "argo.check-out",
    "api.check-out",
  ])
}

variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}

resource "cloudflare_record" "name" {
  for_each = local.domains
  zone_id  = var.cloudflare_zone_id
  name     = each.value
  value    = aws_lightsail_instance.node-a.public_ip_address
  proxied  = false
  type     = "A"
}