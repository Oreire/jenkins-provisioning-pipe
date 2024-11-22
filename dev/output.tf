

output "Nginx" {
  value = aws_instance.frontend_node.public_dns
  
}

output "Nginx_IP" {
  
  value = aws_instance.frontend_node.public_ip
}


output "Pynode" {
  value = aws_instance.backend_node.public_dns
}

output "Pynode_IP" {
  value = aws_instance.backend_node.public_ip
}