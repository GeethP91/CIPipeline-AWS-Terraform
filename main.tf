data "template_file" "shell-script"{
      template = "${file("scripts/git.sh")}"
}

data "template_file" "gitlab_application_user_data"{
      template = "${file("templates/gitlab_application_user_data.tpl")}"
      vars = {
        postgres_database = aws_db_instance.gitlab_postgresql.name
        postgres_username = aws_db_instance.gitlab_postgresql.username
        postgres_password = var.gitlab_postgresql_password
        postgres_endpoint = aws_db_instance.gitlab_postgresql.address
        redis_endpoint = aws_elasticache_replication_group.gitlab_redis.primary_endpoint_address
        cidr = var.vpc_cidr
        gitlab_url = "http://aws_lb.alb_apps.dns_name"
}
}

data "template_cloudinit_config" "config" {
      gzip = "false"
      base64_encode = "false"
      part {
         filename = "gitlab_application_user_data.tpl"
         content_type = "text/cloud-config"
         content = "data.template_file.gitlab_application_user_data.rendered"
}

      part { 
         content_type = "text/x-shellscript"
         content = "data.template_file.shell-script.rendered"
}

}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.rhel.id
  instance_type = "t3.medium"
  key_name = aws_key_pair.default.id
  subnet_id = aws_subnet.public_subnet1.id
  security_groups = ["${aws_security_group.bastion.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "bastion"
  }
}


output "GitLab_One-Time_DB_Command-Primary_Only" {
        value = "force=yes;export force; gitlab-rake gitlab:setup"
}

output "GitLab_One-Time_DB_Command-Primary_Only_2"{
        value = "sudo gitlab-ctl reconfigure"
}

output "Bastion_Public_IP"{
        value = aws_instance.bastion.public_ip
}

output "Devops_Apps_Public_IP_ELB" {
        value = aws_lb.alb_apps.dns_name
}

