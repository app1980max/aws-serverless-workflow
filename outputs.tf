output "queue_url" {
  value = module.sqs.queue_url
}

output "topic_arn" {
  value = module.sns.topic_arn
}

output "table_name" {
  value = module.dynamodb.table_name
}
