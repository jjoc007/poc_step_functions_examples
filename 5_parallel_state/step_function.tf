resource "aws_sfn_state_machine" "sf_slack_notification" {
  name     = "sf_parallel_state_example"
  role_arn = aws_iam_role.step_functions_role.arn

  definition = <<EOF
{
  "Comment": "Ejemplo de Step Function con estados de tipo 'Pass' y agregación de resultados en un estado paralelo",
  "StartAt": "EstadoInicial",
  "States": {
    "EstadoInicial": {
      "Type": "Pass",
      "Result": {
        "mensajeInicial": "Inicio del flujo de trabajo"
      },
      "Next": "ProcesoParalelo"
    },
    "ProcesoParalelo": {
      "Type": "Parallel",
      "ResultPath": "$.resultadosParalelos",
      "Next": "EstadoFinal",
      "Branches": [
        {
          "StartAt": "Rama1",
          "States": {
            "Rama1": {
              "Type": "Pass",
              "Result": {
                "resultadoRama1": "Dato de la Rama 1"
              },
              "End": true
            }
          }
        },
        {
          "StartAt": "Rama2",
          "States": {
            "Rama2": {
              "Type": "Pass",
              "Result": {
                "resultadoRama2": "Dato de la Rama 2"
              },
              "End": true
            }
          }
        }
      ]
    },
    "EstadoFinal": {
      "Type": "Pass",
      "ResultPath": "$.resultadoFinal",
      "InputPath": "$.resultadosParalelos",
      "Result": {
        "mensajeFinal": "Fin del flujo de trabajo"
      },
      "End": true
    }
  }
}

EOF
}
