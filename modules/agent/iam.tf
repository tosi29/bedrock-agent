
resource "aws_iam_role" "agents" {
  name               = "${var.prefix}-agents-role"
  assume_role_policy = data.aws_iam_policy_document.assume_bedrock.json
  tags = {
    Name = "${var.prefix}-agents-role"
  }
}

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
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:agent/*"]
    }
  }
}

data "aws_iam_policy_document" "policy_agents" {
  statement {
    sid     = "AllowModelInvocationForOrchestration"
    effect  = "Allow"
    actions = ["bedrock:InvokeModel"]
    resources = [
      data.aws_bedrock_foundation_model.sonnet.model_arn,
      data.aws_bedrock_foundation_model.haiku.model_arn
    ]
  }
}

resource "aws_iam_policy" "agents" {
  name   = "${var.prefix}-agents-policy"
  policy = data.aws_iam_policy_document.policy_agents.json

  tags = {
    Name = "${var.prefix}-agents-policy"
  }
}

resource "aws_iam_role_policy_attachment" "agents" {
  role       = aws_iam_role.agents.name
  policy_arn = aws_iam_policy.agents.arn
}