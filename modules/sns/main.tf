resource "aws_sns_topic" "this" {
  name = var.topic_name
}

output "topic_arn" {
  value = aws_sns_topic.this.arn
}


variable "topic_name" {
  description = "Name of the SNS topic"
  type        = string
}


