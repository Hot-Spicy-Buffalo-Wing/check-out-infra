locals {
  domains = toset([
    "check-out",
    "argo.check-out",
    "api.check-out",
    "ai.check-out",
    "dashboard.check-out",
    "minio.check-out",
    "*.minio.check-out",
    "minio-dashboard.check-out",
    "postgres.check-out",
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
