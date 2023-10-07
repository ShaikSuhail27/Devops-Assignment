#Private subnet creation
resource "aws_subnet" "default_private_subnet" {
  count = length(var.cidr_block)
  vpc_id     = data.aws_vpc.default.id
  cidr_block = var.cidr_block[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags =merge( 
    var.common_tags,
    {
    Name = "Amazon-Private"
  }
  )
}

resource "aws_eip" "elastic_ip" {
  domain   = "vpc"
}



resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = data.aws_subnet.public_subnet[0].id

  tags = merge (
    var.common_tags,
    {
    Name = "${var.common_tags.Name}-ngw"
  }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [data.aws_internet_gateway.default]
}


resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.default.id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.ngw.id
  # }
  tags =merge ( 
    var.common_tags,
    {
    Name = "${var.common_tags.Name}-private"
  }
  )
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw.id
}


resource "aws_route_table_association" "private" {
  count = length(var.cidr_block)
  subnet_id      = element(aws_subnet.default_private_subnet[*].id,count.index)
  route_table_id = aws_route_table.private.id
}

# Security group creation
resource "aws_security_group" "server_fleet" {
  name        = "allow HTTP"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.default.id
  tags = {
    Name = "server-fleet-sg"
  }
}
resource "aws_security_group" "web-alb-sg" {
  name        = "Web ALB"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.default.id
  tags = {
    Name = "Web ALB"
  }
}

#security group rules creation

resource "aws_security_group_rule" "server_fleet_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.web-alb-sg.id
  security_group_id = aws_security_group.server_fleet.id
}

resource "aws_security_group_rule" "web_alb_server_fleet" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.server_fleet.id
  security_group_id = aws_security_group.web-alb-sg.id
}

resource "aws_security_group_rule" "web_alb_internet" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-alb-sg.id
}


