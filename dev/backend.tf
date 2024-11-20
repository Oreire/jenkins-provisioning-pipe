
# S3 Backend to store state file for Frontend Nodes

terraform {
  backend "s3" {
    bucket = "jenkins-storage-bucket"
    key    = "env/dev/terraform.tfstate" 
    region = "eu-west-2"
      }
}

