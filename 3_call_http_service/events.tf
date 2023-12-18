resource "aws_cloudwatch_event_connection" "slack_test_webhook" {
  name               = "test-slack-notification-connection"
  description        = "test-slack-notification-connection"
  authorization_type = "API_KEY"

  auth_parameters {
    api_key {
      key   = "not-key"
      value = "None"
    }
  }
}