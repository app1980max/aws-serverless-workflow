# Development Environment Configuration
owner_email = "your-email@company.com"
environment = "dev"

# EKS
eks_cluster_version        = "1.34"
eks_node_instance_types    = ["t3.medium"]
eks_endpoint_public_access = true

# RDS
rds_instance_class    = "db.t3.micro"
rds_allocated_storage = 20

# Tags
data_classification = "internal"
