

output "Nginx" {
  value = aws_instance.frontend_node.public_dns
}


output "Pynode" {
  value = aws_instance.backend_node.public_dns
}
