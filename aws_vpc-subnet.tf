# Create vpc
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "VT-Demo"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# VGW Attachment. In this example, the VPN was already setup and this block connects VPC to VGW.
resource "aws_vpn_gateway_attachment" "vpn_attachment" {
  vpc_id         = aws_vpc.main.id
#  vpn_gateway_id = aws_vpn_gateway.vpn.id
  vpn_gateway_id = "vgw-0e0204adb8d228907"
}

# Create a custom route table
resource "aws_default_route_table" "route" {
  default_route_table_id = aws_vpc.main.default_route_table_id
  propagating_vgws = ["vgw-0e0204adb8d228907"]
  route   {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
}

# Create a Subnet1
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-1"
  }
}

# Create a Subnet2
resource "aws_subnet" "subnet-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-2"
  }
}

# Associate subnet with route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_vpc.main.default_route_table_id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet-2.id
  route_table_id = aws_vpc.main.default_route_table_id
}

# Create Security Group
resource "aws_security_group" "ise-demo" {
  name        = "ISE-Demo"
  vpc_id      = aws_vpc.main.id

  ingress {
      description      = "Within VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [aws_vpc.main.cidr_block]
      #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }
  ingress {
      description      = "From on-premises"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["192.168.0.0/16"]
    }
  ingress {
      description      = "SSH from anywhere"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  egress  {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "ISE-Demo"
  }
}
