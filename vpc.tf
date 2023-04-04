# VPC
resource "aws_vpc" "bastion" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

# Subnet
resource "aws_subnet" "bastion-public" {
  vpc_id            = aws_vpc.bastion.id
  cidr_block        = var.vpc-az-public-cider
  availability_zone = var.vpc-az-name
  tags = {
    Name = "${var.name}-public-subnet"
  }
}

resource "aws_subnet" "bastion-private" {
  vpc_id            = aws_vpc.bastion.id
  cidr_block        = var.vpc-az-private-cider
  availability_zone = var.vpc-az-name
  tags = {
    Name = "${var.name}-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "bastion" {
  vpc_id = aws_vpc.bastion.id
  tags = {
    Name = "${var.name}-igw"
  }
}

# Route Table
resource "aws_route_table" "bastion-public" {
  vpc_id = aws_vpc.bastion.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bastion.id
  }
  tags = {
    Name = "${var.name}-public-route-table"
  }
}

resource "aws_route_table" "bastion-private" {
  vpc_id = aws_vpc.bastion.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.bastion.id
  }
  tags = {
    Name = "${var.name}-private-route-table"
  }
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "bastion-public" {
  subnet_id      = aws_subnet.bastion-public.id
  route_table_id = aws_route_table.bastion-public.id
}

resource "aws_route_table_association" "bastion-private" {
  subnet_id      = aws_subnet.bastion-private.id
  route_table_id = aws_route_table.bastion-private.id
}

# DHCP Option Set
resource "aws_default_vpc_dhcp_options" "bastion" {
}

resource "aws_vpc_dhcp_options_association" "bastion" {
  vpc_id          = aws_vpc.bastion.id
  dhcp_options_id = aws_default_vpc_dhcp_options.bastion.id
}

# Security Group
resource "aws_security_group" "bastion" {
  vpc_id = aws_vpc.bastion.id

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "bastion"
    from_port        = 0
    to_port          = 0
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "-1"
    prefix_list_ids  = null
    security_groups  = null
    self             = false
  }]
}
