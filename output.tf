output "client-vpn-endpoint-id" {
  description = "Client VPN Endpoint ID"
  value       = aws_ec2_client_vpn_endpoint.bastion.id
}

output "region" {
  description = "AWS Region"
  value       = var.region
}
