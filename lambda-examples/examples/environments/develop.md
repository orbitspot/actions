# Environment Variables para DEVELOP

Configure estas variáveis no GitHub Environment "develop":

## Configurações Básicas da Lambda
```
LAMBDA_TIMEOUT=60
LAMBDA_MEMORY_SIZE=256
LAMBDA_LOG_RETENTION=7
LAMBDA_RESERVED_CONCURRENCY=-1
```

## Variáveis de Ambiente da Lambda
```
LAMBDA_ENV_VARS={"NODE_ENV":"development","LOG_LEVEL":"debug","ENVIRONMENT":"develop","API_URL":"https://dev-api.orbitspot.com"}
```

## Triggers Configurados

### API Gateway Triggers
```
LAMBDA_API_GATEWAY_TRIGGERS=[{"api_id":"d4c33alv35","resource_id":"h0ebgzn072","http_method":"GET","path":"/health"},{"api_id":"d4c33alv35","resource_id":"h0ebgzn072","http_method":"POST","path":"/webhook"},{"api_id":"vvu27u8aga","resource_id":"hx5807dj99","http_method":"GET","path":"/users"}]
```

### S3 Triggers
```
LAMBDA_S3_TRIGGERS=[{"bucket_name":"lambda-examples-uploads-develop","events":["s3:ObjectCreated:*"],"filter_prefix":"incoming/","filter_suffix":""},{"bucket_name":"lambda-examples-uploads-develop","events":["s3:ObjectRemoved:*"],"filter_prefix":"processed/"}]
```

### SQS Triggers
```
LAMBDA_SQS_TRIGGERS=[{"queue_arn":"arn:aws:sqs:us-east-1:123456789012:lambda-examples-queue-develop","batch_size":5,"maximum_batching_window_in_seconds":5,"enabled":true},{"queue_arn":"arn:aws:sqs:us-east-1:123456789012:lambda-examples-priority-develop","batch_size":3,"maximum_batching_window_in_seconds":2,"enabled":true}]
```

### SNS Triggers
```
LAMBDA_SNS_TRIGGERS=["arn:aws:sns:us-east-1:123456789012:lambda-examples-notifications-develop","arn:aws:sns:us-east-1:123456789012:lambda-examples-alerts-develop"]
```

### CloudWatch Events (Scheduler)
```
LAMBDA_CLOUDWATCH_EVENT_TRIGGERS=[{"rule_name":"test-every-hour","rule_description":"Test trigger every hour in develop","schedule_expression":"cron(0 * * * ? *)","enabled":true},{"rule_name":"daily-cleanup-dev","rule_description":"Daily cleanup for develop","schedule_expression":"cron(0 22 * * ? *)","enabled":true}]
```

### CloudWatch Logs Triggers
```
LAMBDA_CLOUDWATCH_LOG_TRIGGERS=[{"log_group_name":"/aws/apigateway/d4c33alv35","filter_name":"error-filter-develop","filter_pattern":"[timestamp, request_id, ip, user, timestamp, method, path, protocol, status_code=5*, size]"},{"log_group_name":"/aws/lambda/test-function-develop","filter_name":"exception-filter","filter_pattern":"ERROR"}]
```

### Kinesis Triggers
```
LAMBDA_KINESIS_TRIGGERS=[{"event_source_arn":"arn:aws:kinesis:us-east-1:123456789012:stream/lambda-examples-stream-develop","starting_position":"LATEST","batch_size":50,"enabled":true}]
```

### Function URL Configuration
```
LAMBDA_FUNCTION_URL_ENABLED=true
LAMBDA_FUNCTION_URL_AUTH_TYPE=NONE
LAMBDA_FUNCTION_URL_CORS={"allow_credentials":false,"allow_headers":["content-type","x-custom-header"],"allow_methods":["GET","POST","PUT","DELETE","OPTIONS"],"allow_origins":["*"],"expose_headers":["x-request-id"],"max_age":3600}
```

## Permissões IAM
```
LAMBDA_IAM_POLICIES=[{"Effect":"Allow","Action":["s3:GetObject","s3:PutObject","s3:DeleteObject"],"Resource":["arn:aws:s3:::lambda-examples-uploads-develop/*","arn:aws:s3:::lambda-examples-processed-develop/*"]},{"Effect":"Allow","Action":["sqs:ReceiveMessage","sqs:DeleteMessage","sqs:GetQueueAttributes"],"Resource":["arn:aws:sqs:us-east-1:123456789012:lambda-examples-*-develop"]},{"Effect":"Allow","Action":["sns:Publish"],"Resource":["arn:aws:sns:us-east-1:123456789012:lambda-examples-*-develop"]},{"Effect":"Allow","Action":["kinesis:DescribeStream","kinesis:GetRecords","kinesis:GetShardIterator","kinesis:ListStreams"],"Resource":["arn:aws:kinesis:us-east-1:123456789012:stream/lambda-examples-*-develop"]},{"Effect":"Allow","Action":["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"],"Resource":["arn:aws:logs:us-east-1:123456789012:*"]}]
```

## Dead Letter Queue
```
LAMBDA_DLQ_ARN=arn:aws:sqs:us-east-1:123456789012:lambda-examples-dlq-develop
```

## VPC Configuration (se necessário)
```
LAMBDA_VPC_CONFIG=null
```
