resource "aws_security_group" "efs-general"{
          name = "efs-general"
          vpc_id = aws_vpc.default.id
          description = "Allowing incoming NFS ports"
          
          ingress{
            from_port = 2049
            to_port = 2049
            protocol = "tcp"
            cidr_blocks = [var.private_subnet1_cidr, var.private_subnet2_cidr]
           }
      
 
          egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }

         tags = {
           Name = "EFS SG"
}
}


resource "aws_security_group" "bastion"{
          name = "bastion"
          vpc_id = aws_vpc.default.id
          description = "Allowing incoming SSH access and pings"

          ingress{
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = [var.remote_cidr]
           }


          egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }

         tags = {
           Name = "Bastion SG"
}
}


resource "aws_security_group" "jenkins"{
          name = "jenkins"
          vpc_id = aws_vpc.default.id
          description = "Allowing traffic from public subnet"

          ingress{
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = [var.public_subnet1_cidr,var.public_subnet2_cidr]
           }

          ingress{
            from_port = 8080
            to_port = 8080
            protocol = "tcp"
            cidr_blocks = [var.public_subnet1_cidr,var.public_subnet2_cidr,var.private_subnet1_cidr, var.private_subnet2_cidr,var.remote_cidr]
          }

          egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }

         tags = {
           Name = "Jenkins SG"
}
}


resource "aws_security_group" "db"{
          name = "db"
          vpc_id = aws_vpc.default.id
          description = "Allowing traffic from private subnet"

          ingress{
            from_port = 5432
            to_port = 5432
            protocol = "tcp"
            cidr_blocks = [var.private_subnet1_cidr,var.private_subnet2_cidr]
           }


          egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }
         tags = {
           Name = "DB SG"
}
}


resource "aws_security_group" "redis"{
          name = "redis"
          vpc_id = aws_vpc.default.id
          description = "Allowing traffic from private subnet"

          ingress{
            from_port = 6379
            to_port = 6379
            protocol = "tcp"
            cidr_blocks = [var.private_subnet1_cidr,var.private_subnet2_cidr]
           }


          egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }

         tags = {
           Name = "Redis SG"
}
}




resource "aws_security_group" "git"{
          name = "git"
          vpc_id = aws_vpc.default.id
          description = "Allowing traffic from public subnet"

          ingress{
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = [var.public_subnet1_cidr,var.public_subnet2_cidr]
           }

          ingress{
            from_port = 80
            to_port = 80
            protocol = "tcp"
            cidr_blocks = [var.public_subnet1_cidr,var.public_subnet2_cidr,var.private_subnet1_cidr,var.private_subnet2_cidr,var.remote_cidr]
          }
          ingress{
            from_port = 7990
            to_port = 7990
            protocol = "tcp"
            cidr_blocks = [var.public_subnet1_cidr,var.public_subnet2_cidr,var.private_subnet1_cidr,var.private_subnet2_cidr,var.remote_cidr]
          }
          


          egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }


         tags = {
           Name = "Git SG"
}
}

