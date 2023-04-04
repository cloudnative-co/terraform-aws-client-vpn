# Client VPN endpoint
resource "aws_ec2_client_vpn_endpoint" "bastion" {
  description            = "bastion"
  server_certificate_arn = aws_acm_certificate.bastion-server.arn
  security_group_ids     = [aws_security_group.bastion.id]
  vpc_id                 = aws_vpc.bastion.id
  self_service_portal    = "enabled"
  session_timeout_hours  = "8"
  client_cidr_block      = var.client-cidr
  dns_servers            = [var.vpc-dns]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.bastion-client.arn
  }

  connection_log_options {
    enabled = false
  }

  tags = {
    Name = "${var.name}-client-vpn-endpoint"
  }
}

resource "aws_ec2_client_vpn_network_association" "bastion" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.bastion.id
  subnet_id              = aws_subnet.bastion-private.id
}

resource "aws_ec2_client_vpn_authorization_rule" "bastion-private" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.bastion.id
  target_network_cidr    = aws_subnet.bastion-private.cidr_block
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_authorization_rule" "bastion-public" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.bastion.id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "bastion" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.bastion.id
  destination_cidr_block = "0.0.0.0/0"
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.bastion.subnet_id
}

output "client-vpn-endpoint-id" {
  description = "Client VPN Endpoint ID"
  value = aws_ec2_client_vpn_endpoint.bastion.id
}
