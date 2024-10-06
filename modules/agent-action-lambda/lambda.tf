
resource "aws_lambda_function" "this" {
  function_name = "${var.prefix}-function"
  runtime       = "python3.12"
  role          = var.lambda_role_arn

  handler          = "lambda_function.lambda_handler"
  filename         = var.lambda_file_name
  source_code_hash = var.lambda_source_code_hash

  timeout = 180
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromBedrock"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "bedrock.amazonaws.com"
  source_arn    = "arn:aws:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:agent/${var.agent_id}"
}
