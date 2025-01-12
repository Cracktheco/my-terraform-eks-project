terraform {
  backend "s3" {
    bucket         = "secret-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-locks"
    encrypt        = true
  }
}
