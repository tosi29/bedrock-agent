data aws_caller_identity current {}
data aws_region current {}

data "aws_iam_policy_document" "assume_bedrock" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:bedrock:${local.region}:${local.account_id}:agent/*"]
    }
  }
}

resource "aws_iam_role" "agents" {
  name               = "${local.prefix}-agents-role"
  assume_role_policy = data.aws_iam_policy_document.assume_bedrock.json
  tags = {
    Name = "${local.prefix}-agents-role"
  }
}

data "aws_iam_policy_document" "policy_agents" {
  statement {
    sid     = "AllowModelInvocationForOrchestration"
    effect  = "Allow"
    actions = ["bedrock:InvokeModel"]
    resources = [
      local.claude3_5_sonnet_model_arn,
      local.claude3_haiku_model_arn
    ]
  }
}

resource "aws_iam_policy" "agents" {
  name   = "${local.prefix}-agents-policy"
  policy = data.aws_iam_policy_document.policy_agents.json

  tags = {
    Name = "${local.prefix}-agents-policy"
  }
}

resource "aws_iam_role_policy_attachment" "agents" {
  role       = aws_iam_role.agents.name
  policy_arn = aws_iam_policy.agents.arn
}