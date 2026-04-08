exports.handler = async (event) => {
  for (const record of event.Records) {
    const message = JSON.parse(record.Sns.Message);

    console.log(`📧 Email sent to ${message.userEmail}`);
    console.log(`Order ${message.orderId} processed successfully`);

    // Extend with SES / SendGrid here
  }
};
