resource "aws_vpc" "check-out-vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "check-out-subnet" {
  vpc_id                  = aws_vpc.check-out-vpc.id
  cidr_block              = "172.16.0.0/20"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  depends_on              = [aws_route_table.check-out-rtb]
}

resource "aws_route_table" "check-out-rtb" {
  vpc_id = aws_vpc.check-out-vpc.id

  route {
    gateway_id = aws_internet_gateway.gw.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "check-out-rtb-assoc" {
  subnet_id      = aws_subnet.check-out-subnet.id
  route_table_id = aws_route_table.check-out-rtb.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.check-out-vpc.id
}
