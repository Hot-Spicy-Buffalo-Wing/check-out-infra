variable "main_public_key" {
  type      = string
  sensitive = true
}

resource "aws_lightsail_key_pair" "main_public_key" {
  name       = "check-out-main-public-key"
  public_key = var.main_public_key
}

resource "aws_key_pair" "main_public_key" {
  key_name   = "check-out-main-public-key"
  public_key = var.main_public_key
}
