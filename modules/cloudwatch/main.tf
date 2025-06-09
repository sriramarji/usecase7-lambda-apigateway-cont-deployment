resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "/aws/apigateway/http-lambda-api"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/my-lambda"
  retention_in_days = 7
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "Docker-Lambda-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/ApiGateway",
              "4XXError",
              "ApiName",
              "lambda-http-api"
            ],
            [
              "AWS/ApiGateway",
              "5XXError",
              "ApiName",
              "lambda-http-api"
            ]
          ]
          period = 300
          stat   = "Sum"
          region = "ap-south-1"
          title  = "API Gateway Errors"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/Lambda",
              "Errors",
              "FunctionName",
              "my-docker-lambda"
            ],
            [
              "AWS/Lambda",
              "Throttles",
              "FunctionName",
              "my-docker-lambda"
            ]
          ]
          period = 300
          stat   = "Sum"
          region = "ap-south-1"
          title  = "Lambda Errors/Throttles"
        }
      }
    ]
  })
}