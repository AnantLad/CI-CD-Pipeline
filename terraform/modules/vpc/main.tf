# 1. Create the VPC
# 2. Create an Internet Gateway
# 3. Create public subnets 
# 4. Create private subnets
# 5. Create a NAT Gateway(requires an Elastic IP)
# 6. Create route tables and associate them with the subnets


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

    tags = {
        Name = "${var.environment}-vpc"
    }
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id 
        tags = {
            Name = "${var.environment}-igw"
    }
}
resource "aws_subnet" "public" {
    count = length(var.public_subnet)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.environment}-public-subnet-${count.index + 1}"
        "kubernetes.io/role/elb" = "1"
    }
}
resource "aws_subnet" "private" {
    count = length(var.private_subnet)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.environment}-private-subnet-${count.index + 1}"
        "kubernetes.io/role/internal-elb" = "1"
    }
}
resource "aws_eip" "nat" {
    domain = "vpc"
    tags = {
        Name = "${var.environment}-nat-eip"
    } 
}
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public[0].id
    tags = {
        Name = "${var.environment}-nat-gateway"
    }
    depends_on = [aws_internet_gateway.igw]
}
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
     }
    tags = {
         Name = "${var.environment}-public-rt"
    } 
}
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
     }
    tags = {
         Name = "${var.environment}-private-rt"
    } 
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnet)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}