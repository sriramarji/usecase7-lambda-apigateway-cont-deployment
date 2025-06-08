resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Main"
  }
}

data "aws_availability_zones" "az" {
  state = "available"
}

resource "aws_subnet" "public" {
  count                   = var.pub_sub_count

  vpc_id                  = aws_vpc.main.id
  availability_zone       = element(data.aws_availability_zones.az.names, count.index)
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "private" {
  count                   = var.priv_sub_count

  vpc_id                  = aws_vpc.main.id
  availability_zone       = element(data.aws_availability_zones.az.names, count.index)
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  map_public_ip_on_launch = true
  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_eip" "eip" {
  count = var.nat_count
  tags = {
    Name = "Elastic"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = var.nat_count
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}

#here need to give count
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Public-route"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = var.pub_sub_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = var.priv_sub_count

  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Private-route"
  }
}

resource "aws_route" "private" {
  count                  = var.nat_count
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat[count.index].id
}
resource "aws_route_table_association" "private" {
  count          = var.priv_sub_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

/*resource "aws_security_group" "vpc_endpoint" {
  name_prefix = "${var.project_name}-${var.environment}-vpc-endpoint-"
  vpc_id      = aws_vpc.alb-vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc-endpoints-sg"
  }
}*/