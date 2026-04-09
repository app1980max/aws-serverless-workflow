
resource "aws_lambda_function" "this" {
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  filename      = var.file_path
  role          = var.role_arn   # <-- add this line

  timeout = 10   # 🔥 IMPORTANT

  environment {
    variables = var.environment
  }
}

output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "function_arn" {
  value = aws_lambda_function.this.arn
}

