# Staging Environment Configuration
owner_email = "your-email@company.com"
environment = "staging"

# EKS
eks_cluster_version        = "1.35"
eks_node_instance_types    = ["t3.medium"]
eks_endpoint_public_access = false

# RDS
rds_instance_class    = "db.t3.small"
rds_allocated_storage = 50

# Tags
data_classification = "internal"
