output "Nginx_dns" {
  value = aws_instance.node1.public_dns
}

# output "Nginx_IP" {
#   value = aws_instance.node1.public_ip
# }

output "Pynode_dns" {
  value = aws_instance.node2.public_dns
}

# output "Pynode_IP" {
#   value = aws_instance.node2.public_ip
# }