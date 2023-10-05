terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.15.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket = "devops-assignment"
    key    = "VPC"
    region = "ap-southeast-1"
    dynamodb_table = "devops-lock"
  }
}