# Environment Variables para HOMOLOG

Configure estas variáveis no GitHub Environment "homolog":

## Configurações Básicas da Lambda
```
LAMBDA_TIMEOUT=120
LAMBDA_MEMORY_SIZE=512
LAMBDA_LOG_RETENTION=14
LAMBDA_RESERVED_CONCURRENCY=10
```

## Variáveis de Ambiente da Lambda
```
LAMBDA_ENV_VARS={"NODE_ENV":"staging","LOG_LEVEL":"info","ENVIRONMENT":"homolog","API_URL":"https://homolog-api.orbitspot.com"}
```

## Triggers Configurados

### API Gateway Triggers
```
LAMBDA_API_GATEWAY_TRIGGERS=[{"api_id":"ytjegz8a4j","resource_id":"xyz123","http_method":"GET","path":"/health"},{"api_id":"ytjegz8a4j","resource_id":"xyz123","http_method":"POST","path":"/webhook"},{"api_id":"92td23qtud","resource_id":"abc456","http_method":"GET","path":"/users"},{"api_id":"92td23qtud","resource_id":"abc456","http_method":"POST","path":"/process"}]
```

### S3 Triggers
```
LAMBDA_S3_TRIGGERS=[{"bucket_name":"lambda-examples-uploads-homolog","events":["s3:ObjectCreated:*"],"filter_prefix":"incoming/","filter_suffix":".json"},{"bucket_name":"lambda-examples-uploads-homolog","events":["s3:ObjectRemoved:*"],"filter_prefix":"processed/","filter_suffix":""},{"bucket_name":"lambda-examples-backup-homolog","events":["s3:ObjectCreated:*"],"filter_prefix":"backup/","filter_suffix":".tar.gz"}]
```

### SQS Triggers
```
LAMBDA_SQS_TRIGGERS=[{"queue_arn":"arn:aws:sqs:us-east-1:123456789012:lambda-examples-queue-homolog","batch_size":10,"maximum_batching_window_in_seconds":10,"enabled":true},{"queue_arn":"arn:aws:sqs:us-east-1:123456789012:lambda-examples-priority-homolog","batch_size":5,"maximum_batching_window_in_seconds":5,"enabled":true},{"queue_arn":"arn:aws:sqs:us-east-1:123456789012:lambda-examples-batch-homolog","batch_size":20,"maximum_batching_window_in_seconds":15,"enabled":true}]
```

### SNS Triggers
```
LAMBDA_SNS_TRIGGERS=["arn:aws:sns:us-east-1:123456789012:lambda-examples-notifications-homolog","arn:aws:sns:us-east-1:123456789012:lambda-examples-alerts-homolog","arn:aws:sns:us-east-1:123456789012:lambda-examples-monitoring-homolog"]
```

### CloudWatch Events (Scheduler)
```
LAMBDA_CLOUDWATCH_EVENT_TRIGGERS=[{"rule_name":"test-every-30min","rule_description":"Test trigger every 30 minutes in homolog","schedule_expression":"cron(0,30 * * * ? *)","enabled":true},{"rule_name":"daily-report-homolog","rule_description":"Daily report for homolog","schedule_expression":"cron(0 8 * * ? *)","enabled":true},{"rule_name":"weekly-cleanup","rule_description":"Weekly cleanup on Sunday","schedule_expression":"cron(0 2 ? * SUN *)","enabled":true}]
```

### CloudWatch Logs Triggers
```
LAMBDA_CLOUDWATCH_LOG_TRIGGERS=[{"log_group_name":"/aws/apigateway/ytjegz8a4j","filter_name":"error-filter-homolog","filter_pattern":"[timestamp, request_id, ip, user, timestamp, method, path, protocol, status_code=5*, size]"},{"log_group_name":"/aws/apigateway/92td23qtud","filter_name":"warning-filter","filter_pattern":"[timestamp, request_id, level=WARN*, message]"},{"log_group_name":"/aws/lambda/test-function-homolog","filter_name":"exception-filter","filter_pattern":"ERROR"}]
```

### Kinesis Triggers
```
LAMBDA_KINESIS_TRIGGERS=[{"event_source_arn":"arn:aws:kinesis:us-east-1:123456789012:stream/lambda-examples-stream-homolog","starting_position":"LATEST","batch_size":100,"enabled":true},{"event_source_arn":"arn:aws:kinesis:us-east-1:123456789012:stream/lambda-examples-analytics-homolog","starting_position":"TRIM_HORIZON","batch_size":50,"enabled":true}]
```

### Function URL Configuration
```
LAMBDA_FUNCTION_URL_ENABLED=true
LAMBDA_FUNCTION_URL_AUTH_TYPE=AWS_IAM
LAMBDA_FUNCTION_URL_CORS={"allow_credentials":true,"allow_headers":["content-type","authorization","x-custom-header"],"allow_methods":["GET","POST","PUT","DELETE","OPTIONS"],"allow_origins":["https://homolog.orbitspot.com","https://homolog-admin.orbitspot.com"],"expose_headers":["x-request-id"],"max_age":7200}
```

## Permissões IAM
```
LAMBDA_IAM_POLICIES=[{"Effect":"Allow","Action":["s3:GetObject","s3:PutObject","s3:DeleteObject"],"Resource":["arn:aws:s3:::lambda-examples-uploads-homolog/*","arn:aws:s3:::lambda-examples-processed-homolog/*","arn:aws:s3:::lambda-examples-backup-homolog/*"]},{"Effect":"Allow","Action":["sqs:ReceiveMessage","sqs:DeleteMessage","sqs:GetQueueAttributes"],"Resource":["arn:aws:sqs:us-east-1:123456789012:lambda-examples-*-homolog"]},{"Effect":"Allow","Action":["sns:Publish","sns:Subscribe"],"Resource":["arn:aws:sns:us-east-1:123456789012:lambda-examples-*-homolog"]},{"Effect":"Allow","Action":["kinesis:DescribeStream","kinesis:GetRecords","kinesis:GetShardIterator","kinesis:ListStreams"],"Resource":["arn:aws:kinesis:us-east-1:123456789012:stream/lambda-examples-*-homolog"]},{"Effect":"Allow","Action":["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"],"Resource":["arn:aws:logs:us-east-1:123456789012:*"]},{"Effect":"Allow","Action":["rds:DescribeDBInstances"],"Resource":["*"]}]
```

## Dead Letter Queue
```
LAMBDA_DLQ_ARN=arn:aws:sqs:us-east-1:123456789012:lambda-examples-dlq-homolog
```

## VPC Configuration
```
LAMBDA_VPC_CONFIG={"subnet_ids":["subnet-12345","subnet-67890"],"security_group_ids":["sg-abcdef123"]}
```
