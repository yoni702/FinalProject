# Internet VPC
resource "aws_vpc" "partc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "partc"
  }
}

# Subnets
resource "aws_subnet" "partc-public-1" {
  vpc_id                  = aws_vpc.partc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "partc-public-1"
  }
}

resource "aws_subnet" "partc-public-2" {
  vpc_id                  = aws_vpc.partc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1b"

  tags = {
    Name = "partc-public-2"
  }
}

resource "aws_subnet" "partc-private-1" {
  vpc_id                  = aws_vpc.partc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "partc-private-1"
  }
}

resource "aws_subnet" "partc-private-2" {
  vpc_id                  = aws_vpc.partc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1b"

  tags = {
    Name = "partc-private-2"
  }
}


# Internet GW
resource "aws_internet_gateway" "partc-gw" {
  vpc_id = aws_vpc.partc.id

  tags = {
    Name = "partc"
  }
}

# route tables
resource "aws_route_table" "partc-public" {
  vpc_id = aws_vpc.partc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.partc-gw.id
  }

  tags = {
    Name = "partc-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "partc-public-1-a" {
  subnet_id      = aws_subnet.partc-public-1.id
  route_table_id = aws_route_table.partc-public.id
}

resource "aws_route_table_association" "partc-public-2-a" {
  subnet_id      = aws_subnet.partc-public-2.id
  route_table_id = aws_route_table.partc-public.id
}

