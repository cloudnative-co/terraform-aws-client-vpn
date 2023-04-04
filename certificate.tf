resource "aws_acm_certificate" "bastion-server" {
  certificate_chain = file(var.ca-certificate-filename)
  certificate_body  = file(var.server-certificate-filename)
  private_key       = file(var.server-private-key-filename)
}

resource "aws_acm_certificate" "bastion-client" {
  certificate_chain = file(var.ca-certificate-filename)
  certificate_body = file(var.client-certificate-filename)
  private_key      = file(var.client-private-key-filename)
}
