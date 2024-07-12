# Create a VPC
resource "aws_vpc" "lamp-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Lamp VPC"
  }
}
# Create Web Public Subnet
resource "aws_subnet" "lamp-subnet" {
  vpc_id                  = aws_vpc.lamp-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "lamp-subnet"
  }
}
# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lamp-vpc.id
  tags = {
    Name = "Lamp IGW"
  }
}
# Create Web layer route table
resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.lamp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "lamp WebRT"
  }
}
# Create Web Subnet association with Web route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.lamp-subnet.id
  route_table_id = aws_route_table.web-rt.id
}