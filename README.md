<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/873eb11b-4c43-4fa1-bb03-78b4ea9dabb0" />


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

🔎 Query
```
curl -X POST https://zo1ehal9pf.execute-api.us-west-2.amazonaws.com/orders \
  -H "Content-Type: application/json" \
  -d '{
    "items": ["book"],
    "userEmail": "test@example.com"
  }'
```


