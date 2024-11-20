terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69.0"
    }
  }
  required_version = ">= 1.9.5"
}

provider "aws" {
  region     = var.region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY

}

#Create Security Group for two EC2 Instances  named Nginx & Python  

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  # ... other configuration ...
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#Create AWS EC2 Instance (Frontend Node)

resource "aws_instance" "frontend_node" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = var.frontend_node
  }
}

#Create AWS EC2 Instance (Backend Node)

resource "aws_instance" "backend_node" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = var.backend_node
  }
}

