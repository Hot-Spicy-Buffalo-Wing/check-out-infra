resource "aws_lightsail_instance" "node-a" {
  availability_zone = "ap-northeast-2a"
  name              = "check-out-node-a"
  blueprint_id      = "ubuntu_22_04"
  bundle_id         = "small_3_0"
  key_pair_name     = aws_lightsail_key_pair.main_public_key.name
}

resource "aws_lightsail_instance_public_ports" "node-a-public-ports" {
  instance_name = aws_lightsail_instance.node-a.name
  port_info {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidrs     = ["0.0.0.0/0"]
  }
  port_info {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidrs     = ["0.0.0.0/0"]
  }
  port_info {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidrs     = ["0.0.0.0/0"]
  }

  # k3s
  port_info {
    from_port = 6443
    to_port   = 6443
    protocol  = "tcp"
    cidrs     = ["0.0.0.0/0"]
  }
  port_info {
    from_port = 2379
    to_port   = 2379
    protocol  = "tcp"
    cidrs     = ["0.0.0.0/0"]
  }
  port_info {
    from_port = 2380
    to_port   = 2380
    protocol  = "tcp"
    cidrs     = ["0.0.0.0/0"]
  }
}
