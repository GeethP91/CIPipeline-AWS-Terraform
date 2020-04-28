provider "aws"{
          region= var.aws_region
          profile = "devops"
}

variable "region" {
          description = "Region Name"
          default = "eu-west-1"
}

variable "aws_region"{
          description = "EC2 Region for the VPC"
          default = "eu-west-1"
}

variable "remote_cidr"{
          description = "CIDR from the remote testing source"
          default = "0.0.0.0/0"
}

variable "vpc_cidr"{
          description = "CIDR for the whole VPC"
          default = "10.0.0.0/16"
}

variable "public_subnet1_cidr"{
          description = "CIDR for the public subnet 1"
          default = "10.0.1.0/24"
}

variable "public_subnet2_cidr"{
          description = "CIDR for the public subnet 2"
          default = "10.0.2.0/24"
}

variable "private_subnet1_cidr"{
          description = "CIDR for the private subnet 1"
          default = "10.0.3.0/24"
}

variable "private_subnet2_cidr"{
          description = "CIDR for the private subnet 2"
          default = "10.0.4.0/24"
}

variable "private_subnet1_db_cidr"{
          description = "CIDR for the db private subnet 1"
          default = "10.0.5.0/24"
}

variable "private_subnet2_db_cidr"{
     description = "CIDR for the db private subnet 1"
          default = "10.0.6.0/24"
}

variable "key_path"{
          description = "SSH public key path"
          default = "/home/gpriya/.ssh/id_rsa.pub"
}

variable "asg_jenkins_slave_min"{
          description = "Autoscaling Jenkins Minimum Scale"
          default = "1"
}

variable "asg_jenkins_slave_max"{
          description = "Autoscaling Jenkins Maximum Scale"
          default = "2"
}

variable "asg_jenkins_slave_desired"{
          description = "Autoscaling jenkins slave desired scale"
          default = "2"
}

variable "asg_jenkins_master_min"{
          description = "Autoscaling jenkins Master Minimum Scale"
          default = "1"
}

variable "asg_jenkins_master_max"{
          description = "Autoscaling jenkins master maximum scale"
          default = "1"
}

variable "asg_jenkins_master_desired"{
          description = "Autoscaling jenkins master desired scale"
          default = "1"
}

variable "asg_git_min"{
          description = "Autoscaling git servers minimum"
          default = "1"
}

variable "asg_git_max"{
          description = "Autoscaling git servers maximum scale"
          default = "2"
}

variable "asg_git_desired"{
          description = "Autoscaling git desired scale"
          default = "2"
}

variable "data_volume_type"{
          description = "EBS Volume type"
          default = "gp2"
}

variable "data_volume_size"{
          description = "EBS volume size"
          default = "50"
}

variable "root_block_device_size"{
          description = "EBS root volume size"
          default = "50"
}

variable "gitlab_postgresql_password"{
          default = "supersecret"
}

variable "git_rds_multiAZ"{
          default = "false"
}

variable "availability_zones"{
          type = list(string)
          default = ["eu-west-1a","eu-west-1b"]
}
