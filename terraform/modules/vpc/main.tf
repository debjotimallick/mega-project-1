resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "project-1-vpc"
  }
}

resource "aws_subnet" "public" {

  count = length(var.public_subnet_cidrs)

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_cidrs[count.index]

  availability_zone = var.availability_zones[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "project-1-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {

  count = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet_cidrs[count.index]

  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "project-1-private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "project-1-igw"
  }
}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "project-1-public-rt"
  }
}

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "project-1-private-rt"
  }
}

resource "aws_route_table_association" "public" {

  count = length(var.public_subnet_cidrs)

  subnet_id = aws_subnet.public[count.index].id

  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_eip_association" "nat" {
  instance_id   = aws_instance.nat.id
  allocation_id = aws_eip.nat.id
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat.primary_network_interface_id
}
