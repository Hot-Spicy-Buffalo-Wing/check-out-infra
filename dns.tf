locals {
  domains = toset([
    "check-out",
    "argo.check-out",
    "api.check-out",
    "dashboard.check-out",
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
  value    = aws_eip.k3s-static-ip[0].public_ip
  proxied  = false
  type     = "A"
}
