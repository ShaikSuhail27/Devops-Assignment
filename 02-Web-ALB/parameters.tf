resource "aws_ssm_parameter" "web_alb_arn" {
  name  = "/${var.common_tags.Name}/${var.common_tags.Environment}/web_alb_arn"
  type  = "String"
  value = aws_lb_listener.HTTP_listener.arn
}


resource "aws_ssm_parameter" "web_alb_dns_name" {
  name  = "/${var.common_tags.Name}/${var.common_tags.Environment}/web_alb_dns_name"
  type  = "String"
  value = aws_lb.Web_alb.dns_name
}

