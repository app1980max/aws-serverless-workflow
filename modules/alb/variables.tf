variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet IDs for ALB placement"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS. If empty, only HTTP listener is created."
  type        = string
  default     = ""
}

variable "target_port" {
  description = "Port on which targets receive traffic"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
  default     = "/healthz"
}

variable "access_logs_bucket" {
  description = "S3 bucket name for ALB access logs. If empty, access logs are disabled."
  type        = string
  default     = ""
}

variable "waf_acl_arn" {
  description = "ARN of the WAFv2 Web ACL to associate. If empty, no WAF is attached."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
