variable "prefix" {
  type = string
  default = "test"
}

variable "agent_id" {
  type = string
}

variable "lambda_file_name" {
  type = string
}

variable "lambda_source_code_hash" {
  type = string
}

variable "lambda_role_arn"{
  type = string
}