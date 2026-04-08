variable "project_name" {
  description = "Name of the project. Used as a prefix for all resource names."
  type        = string
  default     = "startup-stack"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,28}[a-z0-9]$", var.project_name))
    error_message = "Project name must be 3-30 characters, lowercase alphanumeric and hyphens only, starting with a letter."
  }
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-west-2"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "Must be a valid AWS region format (e.g., us-west-2, eu-central-1)."
  }
}

variable "owner_email" {
  description = "Email of the project owner for tagging and alerts"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.owner_email))
    error_message = "Must be a valid email address."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid CIDR block (e.g., 10.0.0.0/16)."
  }
}

variable "availability_zones" {
  description = "Availability zones (minimum 2 for high availability)"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least 2 availability zones are required for high availability."
  }
}

variable "eks_cluster_version" {
  description = "EKS cluster Kubernetes version"
  type        = string
  default     = "1.27"

  validation {
    condition     = can(regex("^1\\.(2[5-9]|[3-9][0-9])$", var.eks_cluster_version))
    error_message = "EKS cluster version must be 1.25 or higher."
  }
}

variable "eks_node_instance_types" {
  description = "Instance types for EKS node groups"
  type        = list(string)
  default     = ["t3.medium"]

  validation {
    condition     = length(var.eks_node_instance_types) > 0
    error_message = "At least one instance type must be specified."
  }
}

variable "eks_endpoint_public_access" {
  description = "Whether the EKS API endpoint is publicly accessible. Set to false for production."
  type        = bool
  default     = false
}

variable "eks_public_access_cidrs" {
  description = "CIDR blocks allowed to access EKS public API. Only used when eks_endpoint_public_access is true. Defaults to all if public access is enabled."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"

  validation {
    condition     = can(regex("^db\\.", var.rds_instance_class))
    error_message = "RDS instance class must start with 'db.' (e.g., db.t3.micro, db.r5.large)."
  }
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.rds_allocated_storage >= 20 && var.rds_allocated_storage <= 65536
    error_message = "RDS storage must be between 20 GB and 65536 GB."
  }
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  default     = "appdb"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]{0,62}$", var.db_name))
    error_message = "Database name must start with a letter, contain only alphanumeric characters and underscores, max 63 characters."
  }
}

variable "db_username" {
  description = "Master database username"
  type        = string
  default     = "dbadmin"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]{3,62}$", var.db_username)) && !contains(["postgres", "admin", "root", "rdsadmin", "master"], lower(var.db_username))
    error_message = "Username must be 4-63 characters, start with a letter, and not be a reserved word (postgres, admin, root, rdsadmin, master)."
  }
}

variable "alert_email" {
  description = "Email address for CloudWatch alarm notifications. If empty, no email subscription is created."
  type        = string
  default     = ""
}

variable "cost_center" {
  description = "Cost center for billing allocation"
  type        = string
  default     = "engineering"
}

variable "data_classification" {
  description = "Data classification level"
  type        = string
  default     = "internal"

  validation {
    condition     = contains(["public", "internal", "confidential", "restricted"], var.data_classification)
    error_message = "Data classification must be one of: public, internal, confidential, restricted."
  }
}

variable "certificate_arn" {
  description = "ARN of ACM certificate for HTTPS on the ALB. If empty, only HTTP redirect is created."
  type        = string
  default     = ""

  validation {
    condition     = var.certificate_arn == "" || can(regex("^arn:aws:acm:", var.certificate_arn))
    error_message = "Must be a valid ACM certificate ARN or empty."
  }
}
