data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {
  state = "available"
}


output "azs"{
    value = data.aws_availability_zones.available
}

data "aws_subnet" "public_subnet" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = "ap-southeast-1a"
}



data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}