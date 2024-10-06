resource "aws_bedrockagent_agent" "this" {
  agent_name              = "${var.prefix}-agent"
  agent_resource_role_arn = aws_iam_role.agents.arn
  foundation_model        = data.aws_bedrock_foundation_model.haiku.model_id
  prepare_agent           = true
  instruction             = "あなたは仕事のアシスタントです。必要に応じてナレッジベースを参照したり、コードを書いたりして仕事の手助けをしてください。"
}
