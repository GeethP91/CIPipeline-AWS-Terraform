resource "aws_vpc" "default" {
         cidr_block = var.vpc_cidr
         enable_dns_hostnames = "true"

         tags = {
         Name = "Devops_VPC"
}
}

resource "aws_internet_gateway" "igw"{
         vpc_id = aws_vpc.default.id
         tags = {
         Name = "Devops_IGW"
}
}

resource "aws_subnet" "public_subnet1"{
         vpc_id = aws_vpc.default.id
         cidr_block = var.public_subnet1_cidr
         availability_zone = "eu-west-1a"
         tags = {
         Name = "Web_PublicSubnet1"
}
}

resource "aws_subnet" "public_subnet2"{
         vpc_id = aws_vpc.default.id
         cidr_block = var.public_subnet2_cidr
         availability_zone = "eu-west-1b"
         tags = {
         Name = "Web_PublicSubnet2"
}
}

resource "aws_subnet" "private_subnet1"{
         vpc_id = aws_vpc.default.id
         cidr_block = var.private_subnet1_cidr
         availability_zone = "eu-west-1a"
         tags = {
         Name = "App_PrivateSubnet1"
}
}

resource "aws_subnet" "private_subnet2"{
         vpc_id = aws_vpc.default.id
         cidr_block = var.private_subnet2_cidr
         availability_zone = "eu-west-1b"
         tags = {
         Name = "App_PrivateSubnet2"
}
}


resource "aws_subnet" "private_db_subnet1"{
         vpc_id = aws_vpc.default.id
         cidr_block = var.private_subnet1_db_cidr
         availability_zone = "eu-west-1a"
         tags = {
         Name = "DB_PrivateSubnet1"
}
}

resource "aws_subnet" "private_db_subnet2"{
         vpc_id = aws_vpc.default.id
         cidr_block = var.private_subnet2_db_cidr
         availability_zone = "eu-west-1b"
         tags = {
         Name = "DB_PrivateSubnet2"
}
}


resource "aws_db_subnet_group" "default"{
          name = "main-subnet-group"
          subnet_ids = [aws_subnet.private_db_subnet1.id,aws_subnet.private_db_subnet2.id]
          tags = {
          Name = "DB_SubnetGroups"
}
}

resource "aws_eip" "eip_nat"{
          vpc = "true"
}

resource "aws_nat_gateway" "nat_gw1"{
          allocation_id = aws_eip.eip_nat.id
          subnet_id = aws_subnet.private_subnet1.id
          depends_on = [
              aws_internet_gateway.igw
]
}

resource "aws_route_table" "public_route"{
          vpc_id = aws_vpc.default.id
          route {
          cidr_block = "0.0.0.0/0"
          gateway_id = aws_internet_gateway.igw.id
          }
          tags = {
          Name = "Public_Subnet_RT"
}
}

resource "aws_route_table_association" "public_route1"{
          subnet_id = aws_subnet.public_subnet1.id
          route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public_route2"{
          subnet_id = aws_subnet.public_subnet2.id
          route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table" "private_route"{
          vpc_id = aws_vpc.default.id
          route {
          cidr_block = "0.0.0.0/0"
          nat_gateway_id = aws_nat_gateway.nat_gw1.id
          }
          tags = {
          Name = "Private_Subnet_RT"
}
}

resource "aws_route_table_association" "private_route1"{
          subnet_id = aws_subnet.private_subnet1.id
          route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_route2"{
          subnet_id = aws_subnet.private_subnet2.id
          route_table_id = aws_route_table.private_route.id
}




