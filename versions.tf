terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "ap-southeast-1"
  default_tags {
    tags = {
      Name = "do4m-demo"
    }
  }
}