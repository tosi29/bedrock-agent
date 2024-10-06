data aws_caller_identity current {}
data aws_region current {}

data "aws_bedrock_foundation_model" "haiku" {
  model_id = "anthropic.claude-3-haiku-20240307-v1:0"
}

data "aws_bedrock_foundation_model" "sonnet" {
  model_id = "anthropic.claude-3-5-sonnet-20240620-v1:0"
}