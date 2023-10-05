resource "aws_ssm_parameter" "private_subnet_id" {
  name  = "/${var.common_tags.Name}/${var.common_tags.Environment}/private-subnet-id"
  type  = "StringList"
  value = join(",",aws_subnet.default_private_subnet[*].id)
}

resource "aws_ssm_parameter" "server_fleet_sg_id" {
  name  = "/${var.common_tags.Name}/${var.common_tags.Environment}/server_fleet_sg_id"
  type  = "String"
  value = aws_security_group.server_fleet.id
}

resource "aws_ssm_parameter" "web_alb_sg_id" {
  name  = "/${var.common_tags.Name}/${var.common_tags.Environment}/web_alb_sg_id"
  type  = "String"
  value = aws_security_group.web-alb-sg.id
}

resource "aws_ssm_parameter" "default_vpc_id" {
  name  = "/${var.common_tags.Name}/${var.common_tags.Environment}/default_vpc_id"
  type  = "String"
  value = data.aws_vpc.default.id
}

