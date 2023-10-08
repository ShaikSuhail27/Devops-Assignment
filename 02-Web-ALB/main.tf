# Public/Web ALB creation
resource "aws_lb" "Web_alb" {
  name               = "${var.project_name}-Web-ALB"
  internal           = false
  load_balancer_type = "application"
  enable_http2 = true
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  # subnets            = slice(data.aws_subnets.all.ids,0,2)
  subnets =data.aws_subnet.public_subnet[*].id
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-Web-ALB"
    }
  )
}

resource "aws_lb_listener" "HTTP_listener" {
  load_balancer_arn = aws_lb.Web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Devops-Assignment"
      status_code  = "200"
    }
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = "suhaildevops.online"
  records = [
    {
      name    = ""
      type    = "A"
      alias   = {
        name    = aws_lb.Web_alb.dns_name
        zone_id = aws_lb.Web_alb.zone_id
      }
    }

  ]
}