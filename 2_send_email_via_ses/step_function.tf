resource "aws_sfn_state_machine" "sf_principal" {
  name     = "sf_principal"
  role_arn = aws_iam_role.step_functions_role.arn

  definition = <<EOF
{
  "Comment": "Send an email via sf",
  "StartAt": "FirstStep",
  "States": {
    "FirstStep": {
      "Type": "Pass",
      "Result": {
        "subject": "Asunto generado en  FirstStep",
        "message": "Mensaje generado en FirstStep"
      },
      "ResultPath": "$.emailData",
      "Next": "SendEmail"
    },
    "SendEmail": {
      "Type": "Task",
      "Next": "LastStep",
      "Parameters": {
        "Content": {
          "Simple": {
            "Body": {
              "Text": {
                "Charset": "UTF-8",
                "Data.$": "States.Format('Este es el cuerpo del mensaje: {}', $.emailData.message)"
              }
            },
            "Subject": {
              "Charset": "UTF-8",
              "Data.$": "States.Format('Asunto del Correo: {}', $.emailData.subject)"
            }
          }
        },
        "Destination": {
          "ToAddresses": [
            "j.j.o.c007@gmail.com"
          ]
        },
        "FromEmailAddress": "j.j.o.c007@gmail.com"
      },
      "Resource": "arn:aws:states:::aws-sdk:sesv2:sendEmail"
    },
    "LastStep": {
      "Type": "Succeed"
    }
  }
}
EOF
}
