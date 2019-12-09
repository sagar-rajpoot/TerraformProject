provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket         = "sagar-terraform"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "sagar-terraform"
  }
}
