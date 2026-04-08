<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/a433ed19-dfe8-402b-aa3f-7d49b873ba56" />


## AWS Infrastrucure | Workflow
This design represents a cloud-native infrastructure platform built on AWS, fully automated using Infrastructure as Code (Terraform) and CI/CD pipelines via GitHub and GitHub Actions.



🎯 Architecture Overview
```
✅ EKS (Kubernetes Cluster)
✅ RDS (Postgres)
✅ ElastiCache (Redis)
✅ Monitoring (CloudWatch, SNS)
✅ GitHub Actions CI/CD
```


🧱 Features
```
✔ Fully automated provisioning with Terraform
✔ High availability using multiple subnets in different Availability Zones
✔ Secure connectivity between Lambda and RDS
✔ Configurable environment variables for database credentials
✔ Easy to extend for other JSON data source
```



🚀 Deployment Options
```
terraform init
terraform validate
terraform plan -var-file="template.tfvars"
terraform apply -var-file="template.tfvars" -auto-approve

# Development
terraform apply -var-file=environments/dev.tfvars 
terraform apply -var-file=environments/staging.tfvars
```

