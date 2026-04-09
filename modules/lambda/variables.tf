
variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "handler" {
  description = "Lambda handler"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "nodejs18.x"
}

variable "file_path" {
  description = "Path to Lambda deployment ZIP"
  type        = string
}

variable "environment" {
  description = "Lambda environment variables"
  type        = map(string)
  default     = {}
}

variable "role_arn" {
  description = "IAM Role ARN for the Lambda function"
  type        = string
}
