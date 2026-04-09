


provider "aws" {
  region = var.region
}

# ========================
# Core Services
# ========================
module "sqs" {
  source     = "./modules/sqs"
  queue_name = "orders-queue"
}

module "sns" {
  source     = "./modules/sns"
  topic_name = "orders-topic"
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "OrdersTable"
}




resource "aws_iam_role" "lambda_exec" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy_attachment" "lambda_sqs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}



# ========================
# Lambda Functions
# ========================
module "lambda_create" {
  source        = "./modules/lambda"
  function_name = "createOrder"
  handler       = "createOrder.handler"
  file_path     = "${path.module}/functions/createOrder.zip"
  role_arn      = aws_iam_role.lambda_exec.arn
  environment = {
    QUEUE_URL = module.sqs.queue_url
  }
}

module "lambda_process" {
  source        = "./modules/lambda"
  function_name = "processOrder"
  handler       = "processOrder.handler"
  file_path     = "${path.module}/functions/processOrder.zip"
  role_arn      = aws_iam_role.lambda_exec.arn
  environment = {
    TABLE_NAME = module.dynamodb.table_name
    TOPIC_ARN  = module.sns.topic_arn
  }
}

module "lambda_notify" {
  source        = "./modules/lambda"
  function_name = "notifyUser"
  handler       = "notifyUser.handler"
  file_path     = "${path.module}/functions/notifyUser.zip"
  role_arn      = aws_iam_role.lambda_exec.arn
}

# ========================
# Event Wiring
# ========================

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = module.sqs.queue_arn
  function_name    = module.lambda_process.function_arn
  batch_size       = 10

  depends_on = [
    aws_iam_role_policy_attachment.lambda_sqs
  ]
}

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

# ========================
# API Gateway
# ========================
resource "aws_apigatewayv2_api" "api" {
  name          = "serverless-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_create" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = module.lambda_create.function_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "post_orders" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /orders"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_create.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "api_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_create.function_name
  principal     = "apigateway.amazonaws.com"
}


