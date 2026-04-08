const AWS = require('aws-sdk');

const dynamo = new AWS.DynamoDB.DocumentClient();
const sns = new AWS.SNS();

const TABLE_NAME = process.env.TABLE_NAME;
const TOPIC_ARN = process.env.TOPIC_ARN;

exports.handler = async (event) => {
  for (const record of event.Records) {
    const order = JSON.parse(record.body);

    try {
      // Idempotency check
      const existing = await dynamo.get({
        TableName: TABLE_NAME,
        Key: { orderId: order.orderId }
      }).promise();

      if (existing.Item) {
        console.log('Order already processed:', order.orderId);
        continue;
      }

      order.status = 'PROCESSED';

      await dynamo.put({
        TableName: TABLE_NAME,
        Item: order
      }).promise();

      await sns.publish({
        TopicArn: TOPIC_ARN,
        Message: JSON.stringify(order)
      }).promise();

    } catch (err) {
      console.error('Error processing order:', err);
      throw err; // retry via SQS
    }
  }
};
