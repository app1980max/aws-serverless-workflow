provider "aws" {
  region = "us-west-2"
}

module "sqs" {
  source = "./modules/sqs"
}

module "sns" {
  source = "./modules/sns"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "lambda_create" {
  source        = "./modules/lambda"
  function_name = "createOrder"
  handler       = "createOrder.handler"
  file_path     = "../../functions/createOrder.zip"
  environment = {
    QUEUE_URL = module.sqs.queue_url
  }
}

module "lambda_process" {
  source        = "./modules/lambda"
  function_name = "processOrder"
  handler       = "processOrder.handler"
  file_path     = "../../functions/processOrder.zip"
  environment = {
    TABLE_NAME = module.dynamodb.table_name
    TOPIC_ARN  = module.sns.topic_arn
  }
}

module "lambda_notify" {
  source        = "./modules/lambda"
  function_name = "notifyUser"
  handler       = "notifyUser.handler"
  file_path     = "../../functions/notifyUser.zip"
}
