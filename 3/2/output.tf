output "server_private_ip" {
  value = aws_instance.dev_server.private_ip
}

output "server_instance_id" {
  value = aws_instance.dev_server.id
}

