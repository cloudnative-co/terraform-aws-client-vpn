resource "aws_acm_certificate" "bastion" {
  certificate_body = file(var.server-certificate-filename)
  private_key      = file(var.server-private-key-filename)
}
