resource "tls_private_key" "MAIN_KEY_PAIR" {
  count     = var.create_key_pair ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "MAIN_KEY_PAIR" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = "MAIN_KEY_PAIR"
  public_key = tls_private_key.MAIN_KEY_PAIR[0].public_key_openssh

  tags = merge(local.tags, { Name = "MAIN_KEY_PAIR" })
}

resource "local_file" "MAIN_PRIVATE_KEY" {
  count           = var.create_key_pair ? 1 : 0
  content         = tls_private_key.MAIN_KEY_PAIR[0].private_key_pem
  filename        = "${path.module}/MAIN_KEY_PAIR.pem"
  file_permission = "0600"
  depends_on      = [aws_key_pair.MAIN_KEY_PAIR]
}