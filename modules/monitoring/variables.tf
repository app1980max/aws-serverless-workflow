variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "alert_email" {
  description = "Email address for alerts"
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for CloudWatch Logs encryption"
  type        = string
  default     = ""
}

variable "rds_instance_identifier" {
  description = "RDS instance identifier for monitoring alarms"
  type        = string
  default     = ""
}

variable "alb_arn_suffix" {
  description = "ARN suffix of the ALB for monitoring alarms"
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "node_group_asg_name" {
  description = "EKS node group Auto Scaling Group name"
  type        = string
}
