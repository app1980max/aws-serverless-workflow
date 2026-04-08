resource "aws_sqs_queue" "this" {
  name = "orders-queue"
}

output "queue_url" {
  value = aws_sqs_queue.this.id
}
