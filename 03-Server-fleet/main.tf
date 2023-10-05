# target group creation
resource "aws_lb_target_group" "Server-Fleet" {
  name     = "${var.project_name}-Server-fleet-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.default_vpc_id.value
  health_check {
    enabled = true
    healthy_threshold = 2 # it will check the health whether it is good or not
    interval = 15
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 3
  }
  }

  # launch template creation

  resource "aws_launch_template" "Server-fleet" {
  name = "${var.project_name}-Server_fleet_lt"
  image_id = "ami-0eeadc4ab092fef70"#data.aws_ami.Amazon-linux-2.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.server_fleet_sg_id.value]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Server-fleet"
    }
  }
  user_data = filebase64("${path.module}/serverfleet.sh")
}

resource "aws_autoscaling_group" "Server-Fleet" {
  name                      = "${var.project_name}-autoscaling"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 3
  target_group_arns = [aws_lb_target_group.Server-Fleet.arn]
  launch_template {
    id      = aws_launch_template.Server-fleet.id
    version = "$Latest"
  }
  vpc_zone_identifier       = split(",", data.aws_ssm_parameter.private_subnet_id.value)

  tag {
    key                 = "Name"
    value               = "Server-fleet"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}
#Autoscaling policy
resource "aws_autoscaling_policy" "Server-Fleet" {
  # ... other configuration ...
  autoscaling_group_name = aws_autoscaling_group.Server-Fleet.name
  name                   = "cpu"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}



#listener rule
resource "aws_lb_listener_rule" "static" {
  listener_arn = data.aws_ssm_parameter.web_alb_arn.value
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Server-Fleet.arn
  }

  # condition {
  #   path_pattern {
  #     values = ["/static/*"]
  #   }
  # }

  condition {
    host_header {
      values = ["serverfleet.suhaildevops.online"]
    }
  }
}