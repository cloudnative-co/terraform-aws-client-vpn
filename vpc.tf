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
resource "aws_subnet" "bastion" {
  vpc_id            = aws_vpc.bastion.id
  cidr_block        = var.vpc-az-cider
  availability_zone = var.vpc-az-name
  tags = {
    Name = "${var.name}-subnet"
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
resource "aws_route_table" "bastion" {
  vpc_id = aws_vpc.bastion.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bastion.id
  }
  tags = {
    Name = "${var.name}-route-table"
  }
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "bastion" {
  subnet_id      = aws_subnet.bastion.id
  route_table_id = aws_route_table.bastion.id
}

# DHCP Option Set
resource "aws_vpc_dhcp_options" "bastion" {
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    Name = "${var.name}-dhcp-options"
  }
}

resource "aws_vpc_dhcp_options_association" "bastion" {
  vpc_id          = aws_vpc.bastion.id
  dhcp_options_id = aws_vpc_dhcp_options.bastion.id
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
