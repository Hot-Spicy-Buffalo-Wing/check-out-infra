resource "aws_vpc" "check-out-vpc" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "check-out-subnet" {
  vpc_id            = aws_vpc.check-out-vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "ap-northeast-2a"
}
