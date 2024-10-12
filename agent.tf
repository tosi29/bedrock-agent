module "agent" {
  source = "./modules/agent"
}

output "agent_version" {
  value = module.agent.agent_version
}

module "agent-action-lambda-datetime" {
  source = "./modules/agent-action-lambda-1"
  agent_id = module.agent.agent_id
  lambda_file_name = data.archive_file.lambda.output_path
  lambda_source_code_hash = data.archive_file.lambda.output_base64sha256
  lambda_role_arn = aws_iam_role.lambda.arn
  description = "本日の日付を取得する関数です"
  prefix = "test-1"
}

module "agent-action-lambda-vacation" {
  source = "./modules/agent-action-lambda-2"
  agent_id = module.agent.agent_id
  lambda_file_name = data.archive_file.lambda.output_path
  lambda_source_code_hash = data.archive_file.lambda.output_base64sha256
  lambda_role_arn = aws_iam_role.lambda.arn
  description = "休暇の取得可能日数や予約ができる関数です"
  prefix = "test-2"
}

resource "aws_bedrockagent_agent_alias" "this" {
  agent_alias_name = "latest"
  agent_id         = module.agent.agent_id

  lifecycle {
    replace_triggered_by = [
      null_resource.trigger.id
    ]
  }
}

resource "null_resource" "trigger" {
  triggers = {
    always_run = timestamp()
  }
}