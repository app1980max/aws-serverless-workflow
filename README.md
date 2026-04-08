


## AWS Serverless | Workflow




🎯 Architecture Overview
```
✅ API Gateway → Lambda (validation)
✅ SQS for buffering
✅ Lambda workers for async processing
✅ DynamoDB for storage
✅ SNS for notifications
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
```

