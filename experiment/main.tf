#1: API Gateway
resource "aws_apigatewayv2_api" "api" {
  name          = "development-api-gatewayv2"
  protocol_type = "HTTP"
}
#2: VPC Link
resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "development-vpclink"
  security_group_ids = aws_security_group.lb.id
  subnet_ids         = aws_subnet.private.*.id
}
#3: API Integration
resource "aws_apigatewayv2_integration" "api_integration" {
  api_id             = aws_apigatewayv2_api.api.id
  integration_type   = "HTTP_PROXY"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id
  connection_type    = "VPC_LINK"
  description        = "VPC integration"
  integration_method = "ANY"
  integration_uri    = aws_lb.default.id
}
#4: APIGW Route
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.api_integration.id}"
}
#5: APIGW Stage
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}