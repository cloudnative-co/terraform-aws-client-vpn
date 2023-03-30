# Client VPN endpoint
resource "aws_ec2_client_vpn_endpoint" "bastion" {
  description            = "bastion"
  server_certificate_arn = aws_acm_certificate.bastion.arn
  security_group_ids     = [aws_security_group.bastion.id]
  vpc_id                 = aws_vpc.bastion.id
  self_service_portal    = "enabled"
  session_timeout_hours  = "8"
  client_cidr_block      = var.client-cidr

  authentication_options {
    type                           = "federated-authentication"
    saml_provider_arn              = var.client-vpn-saml-provider-arn
    self_service_saml_provider_arn = var.self-service-saml-provider-arn
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

resource "aws_ec2_client_vpn_authorization_rule" "bastion" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.bastion.id
  target_network_cidr    = aws_subnet.bastion-private.cidr_block
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "bastion" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.bastion.id
  destination_cidr_block = "0.0.0.0/0"
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.bastion.subnet_id
}
