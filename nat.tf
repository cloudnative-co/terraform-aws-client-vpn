resource "aws_nat_gateway" "bastion" {
  allocation_id = var.nat-elastic-ip-id
  subnet_id     = aws_subnet.bastion-public.id

  tags = {
    Name = "${var.name}-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.bastion
  ]
}
