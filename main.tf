terraform {
  required_version = ">= 1.6.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  prefix = "test"
}


data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "lambda/src"
  output_path = "lambda/lambda_function.zip"
}

