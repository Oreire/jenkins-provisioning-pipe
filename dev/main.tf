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

#Create Security Group for two EC2 Instances  named Nginx (Node 1)  

resource "aws_security_group" "ssh_sg" {
  name        = "SSH-SG"
  description = "Security Group for Node 1"
  # ... other configuration ...
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

#Create Security Group for two EC2 Instances  named Python (Node 2)

resource "aws_security_group" "tls_sg" {
  name        = "TLS-SG"
  description = "Security Group for Node 2"
  # ... other configuration ...
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 65432
    to_port     = 65432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

#Create AWS EC2 Instance (Frontend Node)

resource "aws_instance" "node1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
  tags = {
    Name = var.node1
  }
}

#Create AWS EC2 Instance (Backend Node)

resource "aws_instance" "node2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.tls_sg.id]
  tags = {
    Name = var.node2
  }
}