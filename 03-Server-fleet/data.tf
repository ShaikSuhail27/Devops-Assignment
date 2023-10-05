data "aws_ssm_parameter" "default_vpc_id" {
  name = "/${var.common_tags.Name}/${var.common_tags.Environment}/default_vpc_id"
}

data "aws_ami" "Amazon-linux-2" {
  most_recent      = true
  name_regex       = "amzn2-ami-kernel-5.10-hvm-2.0.20230926.0-arm64-gp2"
  owners           = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20230926.0-arm64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "aws_ssm_parameter" "server_fleet_sg_id" {
  name = "/${var.common_tags.Name}/${var.common_tags.Environment}/server_fleet_sg_id"
}

data "aws_ssm_parameter" "private_subnet_id" {
  name = "/${var.common_tags.Name}/${var.common_tags.Environment}/private-subnet-id"
}

data "aws_ssm_parameter" "web_alb_arn" {
  name = "/${var.common_tags.Name}/${var.common_tags.Environment}/web_alb_arn"
}

data "aws_ssm_parameter" "web_alb_dns_name" {
  name = "/${var.common_tags.Name}/${var.common_tags.Environment}/web_alb_dns_name"
}
