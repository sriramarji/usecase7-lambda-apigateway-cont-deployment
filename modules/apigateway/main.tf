resource "aws_apigatewayv2_api" "http_api" {
  name          = "lambda-http-api"
  protocol_type = "HTTP"
}

#connection between API Gateway and your Lambda function.
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.integration_uri_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

#which API requests should be routed to Lambda.
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}