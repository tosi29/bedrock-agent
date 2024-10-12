
resource "aws_bedrockagent_agent_action_group" "this" {
  action_group_name          = "${var.prefix}-agent"
  agent_id                   = var.agent_id
  agent_version              = "DRAFT"
  skip_resource_in_use_check = true
  action_group_executor {
    lambda = aws_lambda_function.this.arn
  }
  description = var.description
  function_schema {
    member_functions {
      functions {
        name        = "get_aws_cost_of_last_month"
        description = "Get aws cost of last month per services."
      }
    }
  }
}