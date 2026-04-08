


## AWS Serverless | Workflow




🎯 Architecture Overview
```
✅ API Gateway → Lambda (validation)
✅ SQS for buffering
✅ Lambda workers for async processing
✅ DynamoDB for storage
✅ SNS for notifications
```


🧱 Package Lambdas
```
cd functions
zip createOrder.zip createOrder.js
zip processOrder.zip processOrder.js
zip notifyUser.zip notifyUser.js
```



🚀 Deployment Options
```
terraform init
terraform validate
terraform plan -var-file="template.tfvars"
terraform apply -var-file="template.tfvars" -auto-approve
```

