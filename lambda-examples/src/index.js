/**
 * Lambda Examples - Multi-trigger handler
 * Demonstra como uma Lambda pode processar diferentes tipos de eventos
 */

const AWS = require('aws-sdk');

// Initialize AWS services
const s3 = new AWS.S3();
const sns = new AWS.SNS();
const sqs = new AWS.SQS();

exports.handler = async (event, context) => {
    console.log('Event received:', JSON.stringify(event, null, 2));
    console.log('Context:', JSON.stringify(context, null, 2));
    
    try {
        // Determine event source and route to appropriate handler
        const eventSource = determineEventSource(event);
        console.log('Event source detected:', eventSource);
        
        let result;
        
        switch (eventSource) {
            case 'apigateway':
                result = await handleApiGatewayEvent(event, context);
                break;
                
            case 's3':
                result = await handleS3Event(event, context);
                break;
                
            case 'sqs':
                result = await handleSQSEvent(event, context);
                break;
                
            case 'sns':
                result = await handleSNSEvent(event, context);
                break;
                
            case 'cloudwatch-events':
                result = await handleCloudWatchEvent(event, context);
                break;
                
            case 'cloudwatch-logs':
                result = await handleCloudWatchLogsEvent(event, context);
                break;
                
            case 'kinesis':
                result = await handleKinesisEvent(event, context);
                break;
                
            case 'function-url':
                result = await handleFunctionUrlEvent(event, context);
                break;
                
            default:
                result = await handleUnknownEvent(event, context);
                break;
        }
        
        console.log('Handler result:', JSON.stringify(result, null, 2));
        return result;
        
    } catch (error) {
        console.error('Error processing event:', error);
        
        // For API Gateway, return proper HTTP error
        if (event.requestContext) {
            return {
                statusCode: 500,
                headers: {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Headers': 'Content-Type,Authorization',
                    'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS'
                },
                body: JSON.stringify({
                    error: 'Internal Server Error',
                    message: error.message,
                    requestId: context.awsRequestId
                })
            };
        }
        
        // For other events, throw error to trigger retry/DLQ
        throw error;
    }
};

/**
 * Determine the source of the event
 */
function determineEventSource(event) {
    // API Gateway (via API Gateway or ALB)
    if (event.requestContext) {
        return 'apigateway';
    }
    
    // Function URL
    if (event.version === '2.0' && event.requestContext && event.requestContext.http) {
        return 'function-url';
    }
    
    // S3
    if (event.Records && event.Records[0] && event.Records[0].eventSource === 'aws:s3') {
        return 's3';
    }
    
    // SQS
    if (event.Records && event.Records[0] && event.Records[0].eventSource === 'aws:sqs') {
        return 'sqs';
    }
    
    // SNS
    if (event.Records && event.Records[0] && event.Records[0].eventSource === 'aws:sns') {
        return 'sns';
    }
    
    // Kinesis
    if (event.Records && event.Records[0] && event.Records[0].eventSource === 'aws:kinesis') {
        return 'kinesis';
    }
    
    // CloudWatch Events/EventBridge
    if (event.source && (event['detail-type'] || event.source.startsWith('aws.'))) {
        return 'cloudwatch-events';
    }
    
    // CloudWatch Logs
    if (event.awslogs) {
        return 'cloudwatch-logs';
    }
    
    return 'unknown';
}

/**
 * Handle API Gateway events
 */
async function handleApiGatewayEvent(event, context) {
    console.log('Processing API Gateway event');
    
    const method = event.httpMethod;
    const path = event.path;
    const body = event.body ? JSON.parse(event.body) : null;
    const queryParams = event.queryStringParameters || {};
    const headers = event.headers || {};
    
    // Extract user info from custom authorizer
    const userInfo = event.requestContext.authorizer || {};
    
    console.log('API Gateway request:', {
        method,
        path,
        queryParams,
        userInfo: {
            userId: userInfo.userId,
            tenantId: userInfo.tenantId,
            userEmail: userInfo.userEmail
        }
    });
    
    // Route based on method and path
    let response;
    
    if (method === 'GET' && path === '/health') {
        response = {
            status: 'healthy',
            timestamp: new Date().toISOString(),
            environment: process.env.NODE_ENV || 'development',
            version: '1.0.0'
        };
    } else if (method === 'POST' && path === '/webhook') {
        response = await processWebhook(body, userInfo);
    } else if (method === 'GET' && path === '/users') {
        response = await getUsers(queryParams, userInfo);
    } else {
        return {
            statusCode: 404,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            body: JSON.stringify({
                error: 'Not Found',
                message: `Path ${method} ${path} not found`
            })
        };
    }
    
    return {
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Content-Type,Authorization',
            'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS'
        },
        body: JSON.stringify(response)
    };
}

/**
 * Handle S3 events
 */
async function handleS3Event(event, context) {
    console.log('Processing S3 event');
    
    const results = [];
    
    for (const record of event.Records) {
        const bucket = record.s3.bucket.name;
        const key = decodeURIComponent(record.s3.object.key.replace(/\+/g, ' '));
        const eventName = record.eventName;
        
        console.log(`S3 ${eventName}: ${bucket}/${key}`);
        
        try {
            if (eventName.startsWith('ObjectCreated')) {
                const result = await processS3Upload(bucket, key);
                results.push(result);
            } else if (eventName.startsWith('ObjectRemoved')) {
                const result = await processS3Deletion(bucket, key);
                results.push(result);
            }
        } catch (error) {
            console.error(`Error processing S3 object ${bucket}/${key}:`, error);
            results.push({
                bucket,
                key,
                status: 'error',
                error: error.message
            });
        }
    }
    
    return { processedFiles: results };
}

/**
 * Handle SQS events
 */
async function handleSQSEvent(event, context) {
    console.log('Processing SQS event');
    
    const results = [];
    const batchItemFailures = [];
    
    for (const record of event.Records) {
        try {
            const messageId = record.messageId;
            const body = JSON.parse(record.body);
            
            console.log(`Processing SQS message ${messageId}:`, body);
            
            const result = await processQueueMessage(body, record);
            results.push({
                messageId,
                status: 'success',
                result
            });
            
        } catch (error) {
            console.error(`Error processing SQS message ${record.messageId}:`, error);
            
            // Add to batch failures for partial retry
            batchItemFailures.push({
                itemIdentifier: record.messageId
            });
        }
    }
    
    return {
        batchItemFailures,
        processedMessages: results
    };
}

/**
 * Handle SNS events
 */
async function handleSNSEvent(event, context) {
    console.log('Processing SNS event');
    
    const results = [];
    
    for (const record of event.Records) {
        const message = record.Sns;
        const subject = message.Subject;
        const messageBody = message.Message;
        const topicArn = message.TopicArn;
        
        console.log(`SNS notification from ${topicArn}: ${subject}`);
        
        try {
            const parsedMessage = JSON.parse(messageBody);
            const result = await processSNSNotification(parsedMessage, message);
            results.push(result);
        } catch (error) {
            console.error('Error processing SNS message:', error);
            // SNS doesn't support partial failures, log and continue
            results.push({
                topicArn,
                status: 'error',
                error: error.message
            });
        }
    }
    
    return { processedNotifications: results };
}

/**
 * Handle CloudWatch Events
 */
async function handleCloudWatchEvent(event, context) {
    console.log('Processing CloudWatch Event');
    
    const source = event.source;
    const detailType = event['detail-type'];
    const detail = event.detail;
    
    console.log(`CloudWatch Event: ${source} - ${detailType}`);
    
    let result;
    
    if (source === 'aws.events' || detailType.includes('Scheduled Event')) {
        // Scheduled event (cron job)
        result = await processScheduledTask(event);
    } else {
        // Other AWS service events
        result = await processServiceEvent(event);
    }
    
    return result;
}

/**
 * Handle CloudWatch Logs events
 */
async function handleCloudWatchLogsEvent(event, context) {
    console.log('Processing CloudWatch Logs event');
    
    // Decode and decompress log data
    const zlib = require('zlib');
    const payload = Buffer.from(event.awslogs.data, 'base64');
    const logData = JSON.parse(zlib.gunzipSync(payload).toString());
    
    console.log('Log data:', {
        logGroup: logData.logGroup,
        logStream: logData.logStream,
        messageType: logData.messageType,
        logEventsCount: logData.logEvents.length
    });
    
    const results = [];
    
    for (const logEvent of logData.logEvents) {
        try {
            const result = await processLogEvent(logEvent, logData);
            results.push(result);
        } catch (error) {
            console.error('Error processing log event:', error);
        }
    }
    
    return { processedLogEvents: results };
}

/**
 * Handle Kinesis events
 */
async function handleKinesisEvent(event, context) {
    console.log('Processing Kinesis event');
    
    const results = [];
    
    for (const record of event.Records) {
        try {
            // Decode Kinesis data
            const data = Buffer.from(record.kinesis.data, 'base64').toString();
            const parsedData = JSON.parse(data);
            
            console.log(`Processing Kinesis record ${record.kinesis.sequenceNumber}`);
            
            const result = await processKinesisRecord(parsedData, record);
            results.push(result);
            
        } catch (error) {
            console.error(`Error processing Kinesis record ${record.kinesis.sequenceNumber}:`, error);
            // Kinesis will retry failed records
            throw error;
        }
    }
    
    return { processedRecords: results };
}

/**
 * Handle Function URL events
 */
async function handleFunctionUrlEvent(event, context) {
    console.log('Processing Function URL event');
    
    const method = event.requestContext.http.method;
    const path = event.requestContext.http.path;
    const body = event.body ? JSON.parse(event.body) : null;
    
    console.log(`Function URL request: ${method} ${path}`);
    
    // Simple routing for function URL
    let response;
    
    if (method === 'GET' && path === '/') {
        response = {
            message: 'Lambda Examples Function URL',
            timestamp: new Date().toISOString(),
            method,
            path
        };
    } else {
        response = {
            error: 'Not Found',
            message: `Path ${method} ${path} not found`
        };
    }
    
    return {
        statusCode: method === 'GET' && path === '/' ? 200 : 404,
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(response)
    };
}

/**
 * Handle unknown events
 */
async function handleUnknownEvent(event, context) {
    console.log('Processing unknown event type');
    
    return {
        message: 'Unknown event type processed',
        eventKeys: Object.keys(event),
        timestamp: new Date().toISOString()
    };
}

// Helper functions for specific processing
async function processWebhook(data, userInfo) {
    console.log('Processing webhook:', data);
    return {
        message: 'Webhook processed successfully',
        receivedData: data,
        processedBy: userInfo.userEmail || 'anonymous',
        timestamp: new Date().toISOString()
    };
}

async function getUsers(queryParams, userInfo) {
    console.log('Getting users with params:', queryParams);
    return {
        users: [
            { id: 1, name: 'User 1', tenant: userInfo.tenantId },
            { id: 2, name: 'User 2', tenant: userInfo.tenantId }
        ],
        requestedBy: userInfo.userEmail,
        timestamp: new Date().toISOString()
    };
}

async function processS3Upload(bucket, key) {
    console.log(`Processing S3 upload: ${bucket}/${key}`);
    
    // Example: Get object metadata
    const headResult = await s3.headObject({ Bucket: bucket, Key: key }).promise();
    
    return {
        bucket,
        key,
        size: headResult.ContentLength,
        lastModified: headResult.LastModified,
        contentType: headResult.ContentType,
        status: 'processed'
    };
}

async function processS3Deletion(bucket, key) {
    console.log(`Processing S3 deletion: ${bucket}/${key}`);
    
    return {
        bucket,
        key,
        action: 'deleted',
        status: 'processed'
    };
}

async function processQueueMessage(message, record) {
    console.log('Processing queue message:', message);
    
    // Simulate some processing
    await new Promise(resolve => setTimeout(resolve, 100));
    
    return {
        message: 'Queue message processed',
        originalMessage: message,
        processedAt: new Date().toISOString()
    };
}

async function processSNSNotification(message, snsRecord) {
    console.log('Processing SNS notification:', message);
    
    return {
        message: 'SNS notification processed',
        subject: snsRecord.Subject,
        topicArn: snsRecord.TopicArn,
        processedAt: new Date().toISOString()
    };
}

async function processScheduledTask(event) {
    console.log('Processing scheduled task');
    
    return {
        message: 'Scheduled task executed',
        ruleName: event.resources?.[0]?.split('/')?.pop(),
        executedAt: new Date().toISOString()
    };
}

async function processServiceEvent(event) {
    console.log('Processing service event:', event.source);
    
    return {
        message: 'Service event processed',
        source: event.source,
        detailType: event['detail-type'],
        processedAt: new Date().toISOString()
    };
}

async function processLogEvent(logEvent, logData) {
    console.log('Processing log event:', logEvent.message);
    
    return {
        message: 'Log event processed',
        logGroup: logData.logGroup,
        timestamp: new Date(logEvent.timestamp).toISOString(),
        messageLength: logEvent.message.length
    };
}

async function processKinesisRecord(data, record) {
    console.log('Processing Kinesis record:', data);
    
    return {
        message: 'Kinesis record processed',
        sequenceNumber: record.kinesis.sequenceNumber,
        data: data,
        processedAt: new Date().toISOString()
    };
}
