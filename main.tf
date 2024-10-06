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
  claude3_haiku_model_arn   = "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-haiku-20240229-v1:0"
  claude3_5_sonnet_model_arn = "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-5-sonnet-20240620-v1:0"

  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  prefix = "test"
}

locals {
  prompt = "You are an HR agent, helping employees understand HR policies and manage vacation time"
}