output "aws_security_group_id" {
  description = "The ID of the created security group"
  value       = aws_security_group.example.id
}
