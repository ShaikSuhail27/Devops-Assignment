data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {
  state = "available"
}


output "azs"{
    value = data.aws_availability_zones.available
}

# data "aws_subnet" "public_subnet" {
#   vpc_id = data.aws_vpc.default.id
#   availability_zone = "ap-southeast-1a"
#   filter {
#     name   = "tag:Name"
#     values = ["public_subnet"]
#   }
# }

# data "aws_subnets" "public_subnet" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }
data "aws_subnet" "public_subnet" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                  = data.aws_vpc.default.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  default_for_az           = true
}



data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}