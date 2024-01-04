resource "aws_iam_role" "step_functions_role" {
  name = "step_functions_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "sfn_logging_policy" {
  name        = "SFNLoggingPolicy"
  description = "Allow Step Functions to log to CloudWatch Logs."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sfn_logging_attach" {
  policy_arn = aws_iam_policy.sfn_logging_policy.arn
  role       = aws_iam_role.step_functions_role.name
}
