resource "aws_sfn_state_machine" "sf_slack_notification" {
  name     = "sf_slack_notification"
  role_arn = aws_iam_role.step_functions_role.arn

  definition = <<EOF
{
  "Comment": "Send a slack notification via sf",
  "StartAt": "FirstStep",
  "States": {
    "FirstStep": {
      "Type": "Pass",
      "Result": {
        "type": "INFO",
        "text": "Message from Step Functions"
      },
      "ResultPath": "$.notificationData",
      "Next": "SendNotification"
    },
    "SendNotification": {
      "Type": "Task",
      "Resource": "arn:aws:states:::http:invoke",
      "Parameters": {
        "Authentication": {
          "ConnectionArn": "${aws_cloudwatch_event_connection.slack_test_webhook.arn}"
        },
        "RequestBody": {
          "text.$": "$.notificationData.text",
          "type.$": "$.notificationData.type"
        },
        "ApiEndpoint": "https://hooks.slack.com/triggers/11111111/2222222222/33333333333",
        "Method": "POST"
      },
      "Next": "LastStep"
    },
    "LastStep": {
      "Type": "Succeed"
    }
  }
}
EOF
}
