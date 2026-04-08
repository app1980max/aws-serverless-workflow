locals {
  common_tags = {
    Project            = var.project_name
    Environment        = var.environment
    ManagedBy          = "Terraform"
    Owner              = var.owner_email
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

module "kms" {
  source = "./modules/kms"

  project_name = var.project_name
  environment  = var.environment

  tags = local.common_tags
}

module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  environment       = var.environment
  vpc_cidr          = var.vpc_cidr
  availability_zones = var.availability_zones
  
  tags = local.common_tags
}

module "eks" {
  source = "./modules/eks"

  project_name      = var.project_name
  environment      = var.environment
  cluster_version  = var.eks_cluster_version

  vpc_id           = module.vpc.vpc_id
  vpc_cidr         = var.vpc_cidr
  private_subnets  = module.vpc.private_subnets
  public_subnets   = module.vpc.public_subnets

  endpoint_public_access = var.eks_endpoint_public_access
  public_access_cidrs    = var.eks_public_access_cidrs
  kms_key_arn            = module.kms.eks_kms_key_arn

  node_groups = {
    main = {
      instance_types = var.eks_node_instance_types
      scaling_config = {
        desired_size = var.environment == "prod" ? 3 : 2
        max_size     = var.environment == "prod" ? 10 : 5
        min_size     = var.environment == "prod" ? 2 : 1
      }
    }
  }

  tags = local.common_tags
}

module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  environment        = var.environment

  instance_class     = var.rds_instance_class
  allocated_storage  = var.rds_allocated_storage
  db_name            = var.db_name
  db_username        = var.db_username

  backup_retention_period = var.environment == "prod" ? 30 : 7
  multi_az                = var.environment == "prod" ? true : false

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  kms_key_arn     = module.kms.rds_kms_key_arn

  tags = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  vpc_cidr        = var.vpc_cidr
  public_subnets  = module.vpc.public_subnets
  certificate_arn = var.certificate_arn

  tags = local.common_tags
}

