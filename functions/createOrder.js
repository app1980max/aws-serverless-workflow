
const { SQSClient, SendMessageCommand } = require("@aws-sdk/client-sqs");

// Initialize SQS client with region fallback
const client = new SQSClient({ region: process.env.AWS_REGION || "us-west-2" });

exports.handler = async (event) => {
  console.log("EVENT RECEIVED:", JSON.stringify(event));

  // Check if QUEUE_URL is set
  const queueUrl = process.env.QUEUE_URL;
  if (!queueUrl) {
    console.error("Missing QUEUE_URL environment variable!");
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Server misconfiguration: missing queue URL" }),
    };
  }

  try {
    const body = event.body ? JSON.parse(event.body) : {};

    // Validate input
    if (!Array.isArray(body.items) || !body.userEmail) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: "Invalid input: items array and userEmail are required" }),
      };
    }

    // Create order object
    const order = {
      orderId: Date.now().toString(),
      items: body.items,
      userEmail: body.userEmail,
      status: "CREATED",
      createdAt: new Date().toISOString(),
    };

    const params = {
      QueueUrl: queueUrl,
      MessageBody: JSON.stringify(order),
    };

    // Send message to SQS
    await client.send(new SendMessageCommand(params));
    console.log("Order sent to SQS:", order.orderId);

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Order created", orderId: order.orderId }),
    };
  } catch (err) {
    console.error("ERROR PROCESSING ORDER:", err.stack || err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message || "Internal Server Error" }),
    };
  }
};
