module "agent" {
  source = "./modules/agent"
}

module "agent-action-lambda" {
  source = "./modules/agent-action-lambda"
  agent_id = module.agent.agent_id
  lambda_file_name = data.archive_file.lambda.output_path
  lambda_source_code_hash = data.archive_file.lambda.output_base64sha256
  lambda_role_arn = aws_iam_role.lambda.arn
}

resource "aws_bedrockagent_agent_alias" "this" {
 agent_alias_name = "latest"
 agent_id         = module.agent.agent_id
}
