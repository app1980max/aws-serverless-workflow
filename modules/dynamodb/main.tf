resource "aws_dynamodb_table" "this" {
  name         = "OrdersTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "orderId"

  attribute {
    name = "orderId"
    type = "S"
  }
}

output "table_name" {
  value = aws_dynamodb_table.this.name
}
