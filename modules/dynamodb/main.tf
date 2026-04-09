
resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  hash_key     = var.hash_key
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = var.hash_key
    type = "S"
  }
}

output "table_name" {
  value = aws_dynamodb_table.this.name
}

output "table_arn" {
  value = aws_dynamodb_table.this.arn
}


variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "hash_key" {
  description = "Primary key for the table"
  type        = string
  default     = "id"
}
