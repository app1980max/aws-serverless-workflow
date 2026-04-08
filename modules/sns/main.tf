resource "aws_sns_topic" "this" {
  name = "orders-topic"
}

output "topic_arn" {
  value = aws_sns_topic.this.arn
}
