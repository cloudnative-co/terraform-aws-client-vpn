output "client-vpn-endpoint-id" {
  description = "Client VPN Endpoint ID"
  value       = aws_ec2_client_vpn_endpoint.bastion.id
}

output "region" {
  description = "AWS Region"
  value       = var.region
}

output "client-cert-filename" {
  description = "Client Certificate Filename"
  value       = var.client-certificate-filename
}

output "client-private-key-filename" {
  description = "Client Private Key Filename"
  value       = var.client-private-key-filename
}
