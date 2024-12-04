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
  region     = "eu-west-2"   
}

#Create Security Group for two EC2 Instances  named Nginx (Node 1)  

resource "aws_security_group" "ssh_sg" {
  name        = "SSH-SG"
  description = "Security Group for Nginx Node 1"
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
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

#Create Security Group for two EC2 Instances  named Python (Node 2)

resource "aws_security_group" "tls_sg" {
  name        = "TLS-SG"
  description = "Security Group for Python Node 2"
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
  ami                    = "ami-0b45ae66668865cd6" #var.ami_id
  instance_type          = "t2.micro"              #var.instance_type_id
  key_name               = "NewAxeCred"            #var.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
  tags = {
    Name = var.node1
  }
}

#Create AWS EC2 Instance (Backend Node)

resource "aws_instance" "node2" {
  ami                    = "ami-0b45ae66668865cd6" #var.ami_id
  instance_type          = "t2.micro"              #var.instance_type_id
  key_name               = "NewAxeCred"            #var.key_name
  vpc_security_group_ids = [aws_security_group.tls_sg.id]
  tags = {
    Name = var.node2
  }
}
