##==========================
#datasource.tf
##==========================
data "aws_availability_zones" "available_AZ" {
  state = "available"
}

##==========================
#vpc.tf
##==========================

resource "aws_vpc" "myvpc"{
    cidr_block  = var.vpc_cidr
    instance_tenancy  = "default"
    enable_dns_support  = true
    enable_dns_hostnames  = true
    tags = {
        Name = "${var.project}-myvpc-${var.env}"
        project  = var.project
        env  = var.env
    }
}


##=============================================
###subnets
##=============================================

resource "aws_subnet" "public1" {
    vpc_id  = aws_vpc.myvpc.id
    cidr_block  = cidrsubnet(var.vpc_cidr, "2",0)
    availability_zone  = data.aws_availability_zones.available_AZ.names[0]
    map_public_ip_on_launch  = true
    tags  = {
        Name  = "${var.project}-public1-${var.env}"
        project  = var.project
        env  = var.env

    }

}



resource "aws_subnet" "public2" {
    vpc_id  = aws_vpc.myvpc.id
    cidr_block  = cidrsubnet(var.vpc_cidr, "2",1)
    availability_zone  = data.aws_availability_zones.available_AZ.names[1]
    map_public_ip_on_launch  = true
    tags  = {
        Name  = "${var.project}-public2-${var.env}"
        project  = var.project
        env  = var.env

    }

}





resource "aws_subnet" "private1" {
    vpc_id  = aws_vpc.myvpc.id
    cidr_block  = cidrsubnet(var.vpc_cidr, "2",2)
    availability_zone  = data.aws_availability_zones.available_AZ.names[0]
    map_public_ip_on_launch  = false
    tags  = {
        Name  = "${var.project}-private1-${var.env}"
        project  = var.project
        env  = var.env

    }

}



##========================================
###Route table
##========================================


resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project}-public_rtb-${var.env}"
    project = var.project
    env = var.env
  }
}



##======================================
###Internet gateway
##======================================

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "${var.project}-igw-${var.env}"
    project = var.project
    env = var.env
  }
}


##====================================================
###Route table association
##====================================================

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_rtb.id
}


#resource "aws_route_table_association" "private1" {
#  subnet_id      = aws_subnet.private1.id
#  route_table_id = aws_route_table.private_rtb.id
#}



#"#
##==========================
#variables.tf
##==========================
variable "region" {

default = "ap-south-1"
}

 variable "env" {
     default  = "Devel"
 }

variable "project" {
    default  = "core"
}

variable "vpc_cidr" {
    default  = "172.18.0.0/16"
}

##==========================
#output.tf
##==========================
output "vpc_id" {
  value = aws_vpc.myvpc.id
}

output "subnet_public1_id" {
  value = aws_subnet.public1.id
}

output "subnet_public2_id" {
  value = aws_subnet.public2.id
}


output "subnet_private1_id" {
  value = aws_subnet.private1.id
}

output "security_group_id" {
  value = aws_security_group.lb-sec-grp.id
}

