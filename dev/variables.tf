variable "ami_id" {}

variable "instance_type_id" {}

variable "node2" {}

variable "node1" {}

variable "region" {}

variable "AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY" {

  type      = string
  sensitive = true
}

variable "key_name" {

  type      = string
  sensitive = true
}

