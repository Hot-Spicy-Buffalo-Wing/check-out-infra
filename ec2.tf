data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "k3s" {
  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t4g.micro"
  key_name      = aws_key_pair.main_public_key.key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.check-out-network-interface[count.index].id
  }

  tags = { Name = "k3s ${count.index}" }
}

resource "aws_network_interface" "check-out-network-interface" {
  count           = 3
  subnet_id       = aws_subnet.check-out-subnet.id
  security_groups = [aws_security_group.k3s-security-group.id]
  tags            = { Name = "k3s-network-interface" }
}

resource "aws_security_group" "k3s-security-group" {
  name   = "check-out-control-plane-security-group"
  vpc_id = aws_vpc.check-out-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # k3s
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2379
    to_port     = 2379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2380
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "k3s-static-ip" {
  count             = 3
  instance          = aws_instance.k3s[count.index].id
  network_interface = aws_network_interface.check-out-network-interface[count.index].id
  vpc               = true
  depends_on        = [aws_internet_gateway.gw]
}

output "k3s-static-ip" {
  value = aws_eip.k3s-static-ip[*].public_ip
}

output "k3s-private-ip" {
  value = aws_instance.k3s[*].private_ip
}
