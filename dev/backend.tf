
# S3 Backend to store state file

terraform {
  backend "s3" {
    bucket = "my-jenks-store"
    key    = "env/dev/terraform.tfstate" 
    region = "eu-west-2"
      }
}




