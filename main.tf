
provider "aws" {
  region = var.region
}

module "sqs" {
  source = "./modules/sqs"
  name   = "orders-queue"
}

module "sns" {
  source = "./modules/sns"
  name   = "orders-topic"
}

module "dynamodb" {
  source = "./modules/dynamodb"
  table_name = "OrdersTable"
}

module "lambda_create" {
  source        = "./modules/lambda"
  function_name = "createOrder"
  handler       = "createOrder.handler"
  file_path     = "./functions/createOrder.zip"
  environment = {
    QUEUE_URL = module.sqs.queue_url
  }
}

module "lambda_process" {
  source        = "./modules/lambda"
  function_name = "processOrder"
  handler       = "processOrder.handler"
  file_path     = "./functions/processOrder.zip"
  environment = {
    TABLE_NAME = module.dynamodb.table_name
    TOPIC_ARN  = module.sns.topic_arn
  }
}

module "lambda_notify" {
  source        = "./modules/lambda"
  function_name = "notifyUser"
  handler       = "notifyUser.handler"
  file_path     = "./functions/notifyUser.zip"
}

# Event Wiring

# SQS → Lambda
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = module.sqs.queue_arn
  function_name    = module.lambda_process.function_arn
}

# SNS → Lambda
resource "aws_sns_topic_subscription" "notify_sub" {
  topic_arn = module.sns.topic_arn
  protocol  = "lambda"
  endpoint  = module.lambda_notify.function_arn
}

resource "aws_lambda_permission" "sns_invoke" {
  statement_id  = "AllowSNSInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_notify.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = module.sns.topic_arn
}


