###################### VPC ######################

# Creates the regional VPC. Here we will be using a CIDR
# that allows 2^(32-24) = 2^8 = 256 addresses. With our
# 4 subnets, that means each will get 64 addresses.

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/24"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
}

## An internet gateway to connect to vpc to the internet.
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# The main route table for the vpc.
# Here we will route outbound traffic through the internet gateway.
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

###################### SUBNETS ######################

# Since each subnet will get 64 addresses, we will set the CIDR mask to
# /26 since 2^(32-26) = 2^6 = 64. Since the VPC allows the the last
# 8 bits of the address, will start the subnets at 10.0.0.0 and increments
# by 64 for each consecutive subnet--so, 10.0.0.0, 10.0.0.64, 10.0.0.128, and
# 10.0.0.192.

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/26"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true // Auto assigns ips

  tags = merge(
    var.default_tags,
    { Name = "${var.default_tags.Name}-public" }
  )
}

# Connects the public subnets to the internet through the route table.
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main.id
}