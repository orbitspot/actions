# Exemplos de Payloads para Testes

Este arquivo contém exemplos de payloads para testar cada tipo de trigger da Lambda.

## 1. API Gateway Trigger

### GET /health
```bash
curl -X GET "https://d4c33alv35.execute-api.us-east-1.amazonaws.com/dev/health" \
  -H "Content-Type: application/json"
```

### POST /webhook
```bash
curl -X POST "https://d4c33alv35.execute-api.us-east-1.amazonaws.com/dev/webhook" \
  -H "Content-Type: application/json" \
  -d '{
    "event": "user_created",
    "data": {
      "userId": "12345",
      "email": "test@example.com",
      "timestamp": "2024-01-15T10:30:00Z"
    }
  }'
```

### Payload recebido pela Lambda:
```json
{
  "resource": "/webhook",
  "path": "/webhook",
  "httpMethod": "POST",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": "{\"event\":\"user_created\",\"data\":{\"userId\":\"12345\",\"email\":\"test@example.com\",\"timestamp\":\"2024-01-15T10:30:00Z\"}}",
  "isBase64Encoded": false,
  "requestContext": {
    "apiId": "d4c33alv35"
  }
}
```

## 2. S3 Trigger

### Exemplo de upload de arquivo:
```bash
aws s3 cp test-file.json s3://lambda-examples-uploads-develop/incoming/
```

### Payload recebido pela Lambda:
```json
{
  "Records": [
    {
      "eventVersion": "2.1",
      "eventSource": "aws:s3",
      "eventName": "ObjectCreated:Put",
      "s3": {
        "bucket": {
          "name": "lambda-examples-uploads-develop"
        },
        "object": {
          "key": "incoming/test-file.json",
          "size": 1024
        }
      }
    }
  ]
}
```

## 3. SQS Trigger

### Enviar mensagem para SQS:
```bash
aws sqs send-message \
  --queue-url "https://sqs.us-east-1.amazonaws.com/123456789012/lambda-examples-queue-develop" \
  --message-body '{
    "orderId": "ORDER-12345",
    "customerId": "CUST-67890",
    "items": [
      {"id": "item1", "quantity": 2, "price": 29.99},
      {"id": "item2", "quantity": 1, "price": 15.50}
    ],
    "timestamp": "2024-01-15T10:30:00Z"
  }'
```

### Payload recebido pela Lambda:
```json
{
  "Records": [
    {
      "messageId": "19dd0b57-b21e-4ac1-bd88-01bbb068cb78",
      "body": "{\"orderId\":\"ORDER-12345\",\"customerId\":\"CUST-67890\",\"items\":[{\"id\":\"item1\",\"quantity\":2,\"price\":29.99},{\"id\":\"item2\",\"quantity\":1,\"price\":15.50}],\"timestamp\":\"2024-01-15T10:30:00Z\"}",
      "eventSource": "aws:sqs",
      "eventSourceARN": "arn:aws:sqs:us-east-1:123456789012:lambda-examples-queue-develop"
    }
  ]
}
```

## 4. SNS Trigger

### Publicar mensagem no SNS:
```bash
aws sns publish \
  --topic-arn "arn:aws:sns:us-east-1:123456789012:lambda-examples-notifications-develop" \
  --message '{
    "alert": "High CPU Usage",
    "severity": "WARNING",
    "instance": "i-1234567890abcdef0",
    "value": 85.6,
    "threshold": 80,
    "timestamp": "2024-01-15T10:30:00Z"
  }' \
  --subject "Infrastructure Alert"
```

### Payload recebido pela Lambda:
```json
{
  "Records": [
    {
      "EventSource": "aws:sns",
      "Sns": {
        "Type": "Notification",
        "MessageId": "95df01b4-ee98-5cb9-9903-4c221d41eb5e",
        "TopicArn": "arn:aws:sns:us-east-1:123456789012:lambda-examples-notifications-develop",
        "Subject": "Infrastructure Alert",
        "Message": "{\"alert\":\"High CPU Usage\",\"severity\":\"WARNING\",\"instance\":\"i-1234567890abcdef0\",\"value\":85.6,\"threshold\":80,\"timestamp\":\"2024-01-15T10:30:00Z\"}",
        "Timestamp": "2024-01-15T10:30:00.000Z"
      }
    }
  ]
}
```

## 5. CloudWatch Events (Scheduled)

### Payload recebido pela Lambda (trigger automático):
```json
{
  "version": "0",
  "id": "53dc4d37-cffa-4f76-80c9-8b7d4a4d2eaa",
  "detail-type": "Scheduled Event",
  "source": "aws.events",
  "account": "123456789012",
  "time": "2024-01-15T10:00:00Z",
  "region": "us-east-1",
  "resources": [
    "arn:aws:events:us-east-1:123456789012:rule/test-every-hour"
  ],
  "detail": {}
}
```

## 6. CloudWatch Logs Trigger

### Gerar log que vai disparar o trigger:
```bash
aws logs put-log-events \
  --log-group-name "/aws/apigateway/d4c33alv35" \
  --log-stream-name "2024/01/15/test-stream" \
  --log-events '[
    {
      "timestamp": 1642249800000,
      "message": "2024-01-15T10:30:00Z req-12345 10.0.0.1 user123 2024-01-15T10:30:00Z GET /api/users HTTP/1.1 500 0"
    }
  ]'
```

### Payload recebido pela Lambda:
```json
{
  "awslogs": {
    "data": "H4sIAAAAAAAAAHWPwQqCQBCGX0Xm7EFtK+smZBEUgXoLCdMhFtKV3akI8d0bLYmibvPPN3wz/kzp..."
  }
}
```

## 7. Kinesis Trigger

### Enviar registro para Kinesis:
```bash
aws kinesis put-record \
  --stream-name "lambda-examples-stream-develop" \
  --partition-key "user-activity" \
  --data '{
    "userId": "user123",
    "action": "page_view",
    "page": "/dashboard",
    "timestamp": "2024-01-15T10:30:00Z",
    "metadata": {
      "userAgent": "Mozilla/5.0...",
      "ip": "10.0.0.1"
    }
  }'
```

### Payload recebido pela Lambda:
```json
{
  "Records": [
    {
      "kinesis": {
        "kinesisSchemaVersion": "1.0",
        "partitionKey": "user-activity",
        "sequenceNumber": "49545115243490985018280067714973144582180062593244200961",
        "data": "eyJ1c2VySWQiOiJ1c2VyMTIzIiwiYWN0aW9uIjoicGFnZV92aWV3IiwicGFnZSI6Ii9kYXNoYm9hcmQiLCJ0aW1lc3RhbXAiOiIyMDI0LTAxLTE1VDEwOjMwOjAwWiIsIm1ldGFkYXRhIjp7InVzZXJBZ2VudCI6Ik1vemlsbGEvNS4wLi4uIiwiaXAiOiIxMC4wLjAuMSJ9fQ==",
        "approximateArrivalTimestamp": 1642249800.0
      },
      "eventSource": "aws:kinesis",
      "eventSourceARN": "arn:aws:kinesis:us-east-1:123456789012:stream/lambda-examples-stream-develop"
    }
  ]
}
```

## 8. Function URL Trigger

### Fazer requisição direta para Function URL:
```bash
# URL será algo como: https://abcdefghijk.lambda-url.us-east-1.on.aws/
curl -X POST "https://your-function-url.lambda-url.us-east-1.on.aws/" \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Hello from Function URL",
    "timestamp": "2024-01-15T10:30:00Z"
  }'
```

### Payload recebido pela Lambda:
```json
{
  "version": "2.0",
  "routeKey": "$default",
  "rawPath": "/",
  "headers": {
    "content-type": "application/json"
  },
  "body": "{\"message\":\"Hello from Function URL\",\"timestamp\":\"2024-01-15T10:30:00Z\"}",
  "isBase64Encoded": false,
  "requestContext": {
    "http": {
      "method": "POST",
      "path": "/",
      "protocol": "HTTP/1.1"
    }
  }
}
```

## Scripts de Teste Automatizado

### Teste todos os triggers (develop):
```bash
#!/bin/bash

echo "Testando API Gateway..."
curl -X POST "https://d4c33alv35.execute-api.us-east-1.amazonaws.com/dev/webhook" \
  -H "Content-Type: application/json" \
  -d '{"test": "api-gateway"}'

echo "Testando S3..."
echo '{"test": "s3-trigger"}' > /tmp/test-s3.json
aws s3 cp /tmp/test-s3.json s3://lambda-examples-uploads-develop/incoming/

echo "Testando SQS..."
aws sqs send-message \
  --queue-url "https://sqs.us-east-1.amazonaws.com/123456789012/lambda-examples-queue-develop" \
  --message-body '{"test": "sqs-trigger"}'

echo "Testando SNS..."
aws sns publish \
  --topic-arn "arn:aws:sns:us-east-1:123456789012:lambda-examples-notifications-develop" \
  --message '{"test": "sns-trigger"}'

echo "Testando Kinesis..."
aws kinesis put-record \
  --stream-name "lambda-examples-stream-develop" \
  --partition-key "test" \
  --data '{"test": "kinesis-trigger"}'

echo "Todos os testes enviados! Verifique os logs da Lambda."
```
