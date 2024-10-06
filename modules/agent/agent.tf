resource "aws_bedrockagent_agent" "this" {
  agent_name              = "${var.prefix}-agent"
  agent_resource_role_arn = aws_iam_role.agents.arn
  foundation_model        = "anthropic.claude-3-5-sonnet-20240620-v1:0"
  prepare_agent           = true
  instruction             = "あなたは仕事のアシスタントです。必要に応じてナレッジベースを参照したり、コードを書いたりして仕事の手助けをしてください。"
}
