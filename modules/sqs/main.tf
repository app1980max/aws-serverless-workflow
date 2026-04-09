

resource "aws_sqs_queue" "this" {
  name                       = var.queue_name
  delay_seconds              = 0
  message_retention_seconds  = 86400
}

output "queue_url" {
  value = aws_sqs_queue.this.id
}

output "queue_arn" {
  value = aws_sqs_queue.this.arn
}


variable "queue_name" {
  description = "Name of the SQS queue"
  type        = string
}
