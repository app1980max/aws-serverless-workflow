const { v4: uuidv4 } = require('uuid');
const AWS = require('aws-sdk');

const sqs = new AWS.SQS();
const QUEUE_URL = process.env.QUEUE_URL;

exports.handler = async (event) => {
  try {
    const body = JSON.parse(event.body);

    if (!body.items || !body.userEmail) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'Invalid input' })
      };
    }

    const order = {
      orderId: uuidv4(),
      items: body.items,
      userEmail: body.userEmail,
      status: 'CREATED',
      createdAt: new Date().toISOString()
    };

    await sqs.sendMessage({
      QueueUrl: QUEUE_URL,
      MessageBody: JSON.stringify(order)
    }).promise();

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: 'Order created',
        orderId: order.orderId
      })
    };

  } catch (err) {
    console.error(err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'Internal Server Error' })
    };
  }
};
