# network.tf
# VPC
resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

# Route table
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project}-${var.environment}-rtb"
    Project = var.project
    Env     = var.environment
  }
}

# Route tableと subnetの関連付け
resource "aws_route_table_association" "public_rtb" {
  route_table_id = aws_route_table.rtb.id
  subnet_id      = aws_subnet.public.id
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = var.project
    Env     = var.environment
  }
}

# Route tableとIGWの関連付け
resource "aws_route" "rtb_igw_route" {
  route_table_id         = aws_route_table.rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}