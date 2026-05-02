resource "aws_vpc" "main" { 
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id 

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public-Route-table"
  }
}



resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table" "Private_route_table" {
  vpc_id = aws_vpc.main.id 

  tags = {
    Name = "Private-Route-table"
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.Private_route_table.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.Private_route_table.id
}

# Endpoints (specifically for s3 and dynamodb)

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.${var.region}.s3"
  route_table_ids = [aws_route_table.Private_route_table.id]
}

resource "aws_vpc_endpoint" "DynamoDB" {
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.${var.region}.dynamodb"
  route_table_ids = [aws_route_table.Private_route_table.id]
}

## Internal Endpoints :

resource "aws_vpc_endpoint" "ecr" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-2.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.endpoints.id]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr-api" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-2.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.endpoints.id]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-west-2.ecr.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.endpoints.id]

  private_dns_enabled = true
}

##create a security group for the endpoints

resource "aws_security_group" "endpoints" {
  name        = "endpoints-sg"
  description = "Security group for the endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow https traffic from the browser to reach alb listener"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "endpoints-sg"
  }
}

