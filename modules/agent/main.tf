data aws_caller_identity current {}
data aws_region current {}

locals {
  claude3_haiku_model_arn   = "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-haiku-20240229-v1:0"
  claude3_5_sonnet_model_arn = "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-5-sonnet-20240620-v1:0"
}