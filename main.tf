terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.16"
    }
  }

  backend "s3" {
    bucket = "alonit-tf-state-files"
    key    = "tfstate.json"
    region = "us-east-2"
    # optional: dynamodb_table = "<table-name>"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
#  profile = "931"
}


resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = "t2.nano"

  user_data = file("./deploy.sh")
  key_name = var.key_pair_name
  tags = {
    Name = "alonit-nginx-tf-${var.env}"
    Terraform = "true"
  }
}
