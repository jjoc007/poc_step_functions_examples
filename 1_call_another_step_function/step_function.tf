resource "aws_sfn_state_machine" "sf_principal" {
  name     = "sf_principal"
  role_arn = aws_iam_role.step_functions_role.arn

  definition = <<EOF
{
  "Comment": "Execute another sf",
  "StartAt": "FirstStep",
  "States": {
    "FirstStep": {
      "Type": "Pass",
      "Next": "CallSecondaryStep"
    },
    "CallSecondaryStep": {
      "Type": "Task",
      "Resource": "arn:aws:states:::states:startExecution.sync",
      "Parameters": {
        "StateMachineArn": "${aws_sfn_state_machine.sf_secondary.arn}",
        "Input": {
          "message": "Call from another step function"
        }
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

resource "aws_sfn_state_machine" "sf_secondary" {
  name     = "sf_secondary"
  role_arn = aws_iam_role.step_functions_role.arn

  definition = <<EOF
{
  "Comment": "Ejecuta la Lambda para controlar el estado de un despliegue",
  "StartAt": "WaitForBegin",
  "States": {
    "WaitForBegin": {
      "Type": "Wait",
      "Seconds": 10,
      "Next": "FirstSubStep"
    },
    "FirstSubStep": {
      "Type": "Pass",
      "Next": "LastSubStep"
    },
    "LastSubStep": {
      "Type": "Succeed"
    }
  }
}
EOF
}