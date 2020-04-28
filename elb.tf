data "aws_ami" "rhel" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-7.6_HVM_GA-20190128-x86_64-0-Hourly2-GP2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["309956199498"]
}

data "aws_ami" "amzn" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }

  owners = ["amazon"]
}


resource "aws_lb" "alb_apps" {
  name               = "private-apps-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.git.id}", "${aws_security_group.jenkins.id}"]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  tags = {
    Environment = "Dev"  }
}

resource "aws_lb_target_group" "jenkins-master-8080" {
  name     = "jenkins-master-8080"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id
  health_check{
  path = "/"
  interval = 8
  healthy_threshold = 2
  unhealthy_threshold = 2
  matcher = "200,403"
}
}


resource "aws_lb_target_group" "git-80" {
  name     = "git-80"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.default.id
  health_check{
  path = "/"
  interval = 8
  healthy_threshold = 2
  unhealthy_threshold = 2
  matcher = "200,302"
}
}


resource "aws_lb_listener" "jenkins-master-8080" {
  load_balancer_arn = aws_lb.alb_apps.id
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins-master-8080.id
  }
}


resource "aws_lb_listener" "git-80" {
  load_balancer_arn = aws_lb.alb_apps.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.git-80.id
  }
}


resource "aws_launch_configuration" "git" {
  name_prefix   = "git-"
  image_id      = data.aws_ami.amzn.id
  instance_type = "t3.medium"
  key_name = aws_key_pair.default.id
  security_groups = ["${aws_security_group.git.id}"]
  associate_public_ip_address = false
  user_data = data.template_cloudinit_config.config.rendered
  iam_instance_profile = aws_iam_instance_profile.ec2-readonly-profile.name
  root_block_device {
   volume_size = var.root_block_device_size
}
 ebs_block_device{
  device_name = "/dev/sdf"
  volume_type = var.data_volume_type
  volume_size = var.data_volume_size
}
  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_launch_configuration" "jenkins-master" {
  name_prefix   = "jenkins-master-"
  image_id      = data.aws_ami.rhel.id
  instance_type = "t3.medium"
  key_name = aws_key_pair.default.id
  security_groups = ["${aws_security_group.jenkins.id}"]
  associate_public_ip_address = false
  user_data = file("scripts/jenkins-master.sh")
  iam_instance_profile = aws_iam_instance_profile.ec2-readonly-profile.name
  root_block_device {
   volume_size = var.root_block_device_size
}
 ebs_block_device{
  device_name = "/dev/sdf"
  volume_type = var.data_volume_type
  volume_size = var.data_volume_size
}
  lifecycle {
    create_before_destroy = true
  }
depends_on = [
    aws_nat_gateway.nat_gw1
]
}



resource "aws_launch_configuration" "jenkins-slave" {
  name_prefix   = "jenkins-slave-"
  image_id      = data.aws_ami.rhel.id
  instance_type = "t3.medium"
  key_name = aws_key_pair.default.id
  security_groups = ["${aws_security_group.jenkins.id}"]
  associate_public_ip_address = false
  user_data = file("scripts/jenkins-slave.sh")
  root_block_device {
   volume_size = var.root_block_device_size
}
 ebs_block_device{
  device_name = "/dev/sdf"
  volume_type = var.data_volume_type
  volume_size = var.data_volume_size
}
  lifecycle {
    create_before_destroy = true
  }
depends_on = [
      aws_nat_gateway.nat_gw1
]
}


resource "aws_autoscaling_group" "jenkins-master" {
  name = "jenkins-master"
  launch_configuration = aws_launch_configuration.jenkins-master.name
  desired_capacity   = var.asg_jenkins_master_desired
  max_size           = var.asg_jenkins_master_max
  min_size           = var.asg_jenkins_master_min
  vpc_zone_identifier = [aws_subnet.private_subnet1.id,aws_subnet.private_subnet2.id]
  
  target_group_arns = [aws_lb_target_group.jenkins-master-8080.id]
  lifecycle {
    create_before_destroy = true
  }
  tags = [
{
    key = "Name"
    value = "jenkins-master"
    propagate_at_launch = true
}
]
 depends_on = [aws_efs_mount_target.Jenkins-Master-Priv1,aws_efs_mount_target.Jenkins-Master-Priv1] 
}


resource "aws_autoscaling_group" "jenkins-slave" {
  name = "jenkins-slave"
  launch_configuration = aws_launch_configuration.jenkins-slave.name
  desired_capacity   = var.asg_jenkins_slave_desired
  max_size           = var.asg_jenkins_slave_max
  min_size           = var.asg_jenkins_slave_min
  vpc_zone_identifier = [aws_subnet.private_subnet1.id,aws_subnet.private_subnet2.id]

  target_group_arns = [aws_lb_target_group.jenkins-master-8080.id]
  lifecycle {
    create_before_destroy = true
  }
  tags = [
{
    key = "Name"
    value = "jenkins-slave"
    propagate_at_launch = true
}
]
 
}


resource "aws_autoscaling_group" "git" {
  name = "git"
  launch_configuration = aws_launch_configuration.git.name
  desired_capacity   = var.asg_git_desired
  max_size           = var.asg_git_max
  min_size           = var.asg_git_min
  vpc_zone_identifier = [aws_subnet.private_subnet1.id,aws_subnet.private_subnet2.id]

  target_group_arns = [aws_lb_target_group.git-80.id]
  lifecycle {
    create_before_destroy = true
  }
  tags = [
{
    key = "Name"
    value = "GitLab"
    propagate_at_launch = true
}
]
 depends_on = [aws_db_instance.gitlab_postgresql,aws_efs_mount_target.Git-ssh-Priv1,aws_efs_mount_target.Git-ssh-Priv2,aws_efs_mount_target.Git-rails-uploads-Priv1,aws_efs_mount_target.Git-rails-uploads-Priv2, aws_efs_mount_target.Git-rails-shared-Priv1, aws_efs_mount_target.Git-rails-shared-Priv2,aws_efs_mount_target.Git-Builds-Priv1, aws_efs_mount_target.Git-Builds-Priv2,aws_efs_mount_target.Git-data-Priv1,aws_efs_mount_target.Git-data-Priv2]
}
