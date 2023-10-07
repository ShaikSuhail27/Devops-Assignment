data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "/${var.common_tags.Name}/${var.common_tags.Environment}/web_alb_sg_id"
}

data "aws_ssm_parameter" "private_subnet_id" {
  name = "/${var.common_tags.Name}/${var.common_tags.Environment}/private-subnet-id"
}


data "aws_vpc" "default" {
  default = true
}

# data "aws_subnet" "default_subnet" {
#   vpc_id = data.aws_vpc.default.id
#   filter {
#     name   = "tag:Name"
#     values = ["public-*"]
#   }
# }
 
#  data "aws_subnet" "public_subnets" {
#   count = 2  # You can change this count if you need more subnets
#   vpc_id           = data.aws_vpc.default.id
#   availability_zone = element(["172.31.32.0/20", "172.31.16.0/20"], count.index)
# }
  

  # data "aws_subnet" "public_subnets" {
  # count = 2  # You can change this count if you need more subnets
  # vpc_id = data.aws_vpc.default.id

  # tags = {
  #   "Name" = element(["ap-southeast-1a", "ap-southeast-1b"], count.index)  # Specify unique tag values for each subnet
  # }
  # }


#   data "aws_subnets" "all" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }

data "aws_availability_zones" "available" {
  exclude_names = ["ap-southeast-1c"]
}

data "aws_subnet" "public_subnet" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id                  = data.aws_vpc.default.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  default_for_az           = true
}

output "ps"{
  value=data.aws_subnet.public_subnet
}
