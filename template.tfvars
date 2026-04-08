# Copy this file to terraform.tfvars and fill in your values
# For environment-specific defaults, see: environments/{dev,staging,prod}.tfvars

# Required
owner_email = "your-email@company.com"

# Project
project_name = "my-startup"
environment  = "dev"                    # dev | staging | prod
aws_region   = "us-west-2"

# VPC
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b"]

# EKS
eks_cluster_version        = "1.35"
eks_node_instance_types    = ["t3.medium"]
eks_endpoint_public_access = true       # Set to true only for dev with restricted CIDRs
eks_public_access_cidrs    = ["0.0.0.0/0"] # e.g., ["203.0.113.0/24"] — your office IP

# RDS
rds_instance_class    = "db.t3.micro"   # Use db.r5.large+ for production
rds_allocated_storage = 20              # GB — increase for production
db_name               = "appdb"
db_username           = "dbadmin"

# ALB
certificate_arn = ""                     # ACM certificate ARN for HTTPS

# Alerts
alert_email = "your-email@company.com"

# Tags
cost_center         = "engineering"
data_classification = "internal"         # public | internal | confidential | restricted
