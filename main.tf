#create VPC

resource "aws_vpc" "main" {
  #count      = var.create_vpc ? 1 : 0
  cidr_block = var.vpc-cidr
  

  instance_tenancy     = var.instance-tenany
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    "Name"=var.name}
    
  
}
data "aws_availability_zones" "available" {}
#create subnets
resource "aws_subnet" "private" {
    count = length(var.public_subnets)
    vpc_id     = aws_vpc.main.id
    cidr_block = element(var.private_subnets,count.index)
    availability_zone       = data.aws_availability_zones.available.names[count.index]

    
    tags = {
        "name" = var.project-name
    }


}
resource "aws_subnet" "public" {

    count = length(var.public_subnets)
    vpc_id                  = aws_vpc.main.id
    cidr_block = element(var.public_subnets,count.index)
    map_public_ip_on_launch = var.mapPublicIP
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    tags = {
        "name" = var.project-name
    }


}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
      "name" = var.project-name
    }
  
}
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    tags = {
      "name" = var.project-name
    }

  
}
resource "aws_route" "public-route" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  
}
resource "aws_route_table_association" "rta" {
    count = length(var.public_subnets)
    subnet_id = element(aws_subnet.public.*.id, count.index)
    route_table_id = aws_route_table.public.id
  
}
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    tags = {
      "name" = var.project-name
    }

  
}
resource "aws_route_table_association" "prta" {
    subnet_id = element(aws_subnet.private.*.id, count.index)
    count = length(var.private_subnets)
    route_table_id = aws_route_table.private.id

  
}
resource "aws_eip" "elip" {
    vpc = true
    tags = {
      "name" = var.project-name
    }
  
}
resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.elip.id
    subnet_id = aws_subnet.public[0].id
  
}
resource "aws_route" "private-route" {
    destination_cidr_block = "0.0.0.0/0"
    route_table_id = aws_route_table.private.id
    nat_gateway_id = aws_nat_gateway.ngw.id
  
}
resource "aws_security_group" "ssh" {
    name="ec2-ssh"
    vpc_id = aws_vpc.main.id
    ingress {
        description      = "TLS from VPC"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  
}