# Environment Variables para MASTER (Production)

Configure estas variáveis no GitHub Environment "master":

## Configurações Básicas da Lambda
```
LAMBDA_TIMEOUT=300
LAMBDA_MEMORY_SIZE=1024
LAMBDA_LOG_RETENTION=30
LAMBDA_RESERVED_CONCURRENCY=50
```

## Variáveis de Ambiente da Lambda
```
LAMBDA_ENV_VARS={"NODE_ENV":"production","LOG_LEVEL":"error","ENVIRONMENT":"master","API_URL":"https://api.orbitspot.com"}
```

## Triggers Configurados

### API Gateway Triggers
```
LAMBDA_API_GATEWAY_TRIGGERS=[{"api_id":"m31l8hkoch","resource_id":"prod123","http_method":"GET","path":"/health"},{"api_id":"m31l8hkoch","resource_id":"prod123","http_method":"POST","path":"/webhook"},{"api_id":"4lk2vqj9z0","resource_id":"prod456","http_method":"GET","path":"/users"},{"api_id":"4lk2vqj9z0","resource_id":"prod456","http_method":"POST","path":"/process"},{"api_id":"4lk2vqj9z0","resource_id":"prod456","http_method":"PUT","path":"/update"}]
```

### S3 Triggers
```
LAMBDA_S3_TRIGGERS=[{"bucket_name":"lambda-examples-uploads-production","events":["s3:ObjectCreated:*"],"filter_prefix":"incoming/","filter_suffix":".json"},{"bucket_name":"lambda-examples-uploads-production","events":["s3:ObjectRemoved:*"],"filter_prefix":"processed/","filter_suffix":""},{"bucket_name":"lambda-examples-backup-production","events":["s3:ObjectCreated:*"],"filter_prefix":"backup/","filter_suffix":".tar.gz"},{"bucket_name":"lambda-examples-analytics-production","events":["s3:ObjectCreated:*"],"filter_prefix":"analytics/","filter_suffix":".csv"}]
```

### SQS Triggers
```
LAMBDA_SQS_TRIGGERS=[{"queue_arn":"arn:aws:sqs:us-east-1:123456789012:lambda-examples-queue-production","batch_size":10,"maximum_batching_window_in_seconds":10,"enabled":true},{"queue_arn":"arn:aws:sqs:us-east-1:123456789012:lambda-examples-priority-production","batch_size":5,"maximum_batching_window_in_seconds":5,"enabled":true},{"queue_arn":"arn:aws:sqs:us-east-1:123456789012:lambda-examples-batch-production","batch_size":100,"maximum_batching_window_in_seconds":30,"enabled":true},{"queue_arn":"arn:aws:sqs:us-east-1:123456789012:lambda-examples-critical-production","batch_size":1,"maximum_batching_window_in_seconds":1,"enabled":true}]
```

### SNS Triggers
```
LAMBDA_SNS_TRIGGERS=["arn:aws:sns:us-east-1:123456789012:lambda-examples-notifications-production","arn:aws:sns:us-east-1:123456789012:lambda-examples-alerts-production","arn:aws:sns:us-east-1:123456789012:lambda-examples-monitoring-production","arn:aws:sns:us-east-1:123456789012:lambda-examples-critical-production"]
```

### CloudWatch Events (Scheduler)
```
LAMBDA_CLOUDWATCH_EVENT_TRIGGERS=[{"rule_name":"hourly-health-check","rule_description":"Hourly health check in production","schedule_expression":"cron(0 * * * ? *)","enabled":true},{"rule_name":"daily-report-production","rule_description":"Daily report for production","schedule_expression":"cron(0 6 * * ? *)","enabled":true},{"rule_name":"weekly-maintenance","rule_description":"Weekly maintenance on Sunday 2 AM","schedule_expression":"cron(0 2 ? * SUN *)","enabled":true},{"rule_name":"monthly-analytics","rule_description":"Monthly analytics on 1st day of month","schedule_expression":"cron(0 4 1 * ? *)","enabled":true}]
```

### CloudWatch Logs Triggers
```
LAMBDA_CLOUDWATCH_LOG_TRIGGERS=[{"log_group_name":"/aws/apigateway/m31l8hkoch","filter_name":"error-filter-production","filter_pattern":"[timestamp, request_id, ip, user, timestamp, method, path, protocol, status_code=5*, size]"},{"log_group_name":"/aws/apigateway/4lk2vqj9z0","filter_name":"critical-filter","filter_pattern":"[timestamp, request_id, level=CRITICAL*, message]"},{"log_group_name":"/aws/lambda/test-function-production","filter_name":"exception-filter","filter_pattern":"ERROR"},{"log_group_name":"/aws/rds/instance/production-db/error","filter_name":"db-error-filter","filter_pattern":"ERROR"}]
```

### Kinesis Triggers
```
LAMBDA_KINESIS_TRIGGERS=[{"event_source_arn":"arn:aws:kinesis:us-east-1:123456789012:stream/lambda-examples-stream-production","starting_position":"LATEST","batch_size":100,"enabled":true},{"event_source_arn":"arn:aws:kinesis:us-east-1:123456789012:stream/lambda-examples-analytics-production","starting_position":"TRIM_HORIZON","batch_size":500,"enabled":true},{"event_source_arn":"arn:aws:kinesis:us-east-1:123456789012:stream/lambda-examples-realtime-production","starting_position":"LATEST","batch_size":10,"enabled":true}]
```

### Function URL Configuration
```
LAMBDA_FUNCTION_URL_ENABLED=true
LAMBDA_FUNCTION_URL_AUTH_TYPE=AWS_IAM
LAMBDA_FUNCTION_URL_CORS={"allow_credentials":true,"allow_headers":["content-type","authorization","x-api-key"],"allow_methods":["GET","POST","PUT","DELETE","OPTIONS"],"allow_origins":["https://orbitspot.com","https://admin.orbitspot.com","https://api.orbitspot.com"],"expose_headers":["x-request-id","x-rate-limit"],"max_age":86400}
```

## Permissões IAM
```
LAMBDA_IAM_POLICIES=[{"Effect":"Allow","Action":["s3:GetObject","s3:PutObject","s3:DeleteObject"],"Resource":["arn:aws:s3:::lambda-examples-uploads-production/*","arn:aws:s3:::lambda-examples-processed-production/*","arn:aws:s3:::lambda-examples-backup-production/*","arn:aws:s3:::lambda-examples-analytics-production/*"]},{"Effect":"Allow","Action":["sqs:ReceiveMessage","sqs:DeleteMessage","sqs:GetQueueAttributes"],"Resource":["arn:aws:sqs:us-east-1:123456789012:lambda-examples-*-production"]},{"Effect":"Allow","Action":["sns:Publish","sns:Subscribe"],"Resource":["arn:aws:sns:us-east-1:123456789012:lambda-examples-*-production"]},{"Effect":"Allow","Action":["kinesis:DescribeStream","kinesis:GetRecords","kinesis:GetShardIterator","kinesis:ListStreams","kinesis:PutRecords"],"Resource":["arn:aws:kinesis:us-east-1:123456789012:stream/lambda-examples-*-production"]},{"Effect":"Allow","Action":["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"],"Resource":["arn:aws:logs:us-east-1:123456789012:*"]},{"Effect":"Allow","Action":["rds:DescribeDBInstances","rds:Connect"],"Resource":["*"]},{"Effect":"Allow","Action":["secretsmanager:GetSecretValue"],"Resource":["arn:aws:secretsmanager:us-east-1:123456789012:secret:lambda-examples/*"]},{"Effect":"Allow","Action":["ssm:GetParameter","ssm:GetParameters","ssm:GetParametersByPath"],"Resource":["arn:aws:ssm:us-east-1:123456789012:parameter/lambda-examples/*"]}]
```

## Dead Letter Queue
```
LAMBDA_DLQ_ARN=arn:aws:sqs:us-east-1:123456789012:lambda-examples-dlq-production
```

## VPC Configuration
```
LAMBDA_VPC_CONFIG={"subnet_ids":["subnet-prod123","subnet-prod456","subnet-prod789"],"security_group_ids":["sg-prodweb123","sg-proddb456"]}
```

## Alerting & Monitoring
```
LAMBDA_ALARM_THRESHOLD_ERROR_RATE=0.01
LAMBDA_ALARM_THRESHOLD_DURATION=30000
LAMBDA_ALARM_THRESHOLD_THROTTLES=5
LAMBDA_SNS_ALARM_TOPIC=arn:aws:sns:us-east-1:123456789012:lambda-examples-alarms-production
```
