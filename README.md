# terraform-aws-client-vpn

Create an AWS Client VPN with terraform to access the Internet via AWS.

## Requirements

* terraform 1.4.2 later
* jq (for export client vpn connection configuretion by shell script)

## Variables

### nat-elastic-ip-id

ID of the Elastic IP address to attach to the NAT gateway. To prevent accidental deletion, do not create an Elastic IP with terraform, use an existing one.

### ca-certificate-filename

Server certificate and client certificate are assumed to be issued by the same CA.

## How to Export client VPN configuration

Running `export-client-vpn-connection-configuration.sh` will export the client configuration.

```
export-client-vpn-connection-configuration.sh > config.ovpn
```
