resource "aws_efs_file_system" "jenkins"{
          creation_token = "jenkins-efs"
          encrypted = true
          kms_key_id = aws_kms_key.jenkins-kms.arn
          tags = {
          Name = "Jenkins-EFS"
}
}

resource "aws_efs_mount_target" "Jenkins-Master-Priv1" {
  file_system_id = aws_efs_file_system.jenkins.id
  subnet_id      = aws_subnet.private_subnet1.id
  security_groups = ["${aws_security_group.efs-general.id}"]
}


resource "aws_efs_mount_target" "Jenkins-Master-Priv2" {
  file_system_id = aws_efs_file_system.jenkins.id
  subnet_id      = aws_subnet.private_subnet2.id
  security_groups = ["${aws_security_group.efs-general.id}"]
}



resource "aws_efs_file_system" "git-ssh"{
          creation_token = "git-ssh-efs"
          encrypted = true
          kms_key_id = aws_kms_key.git-kms.arn
          tags = {
          Name = "Git-SSH"
}
}

resource "aws_efs_mount_target" "Git-ssh-Priv1" {
  file_system_id = aws_efs_file_system.git-ssh.id
  subnet_id      = aws_subnet.private_subnet1.id
  security_groups = ["${aws_security_group.efs-general.id}"]
}

resource "aws_efs_mount_target" "Git-ssh-Priv2" {
  file_system_id = aws_efs_file_system.git-ssh.id
  subnet_id      = aws_subnet.private_subnet2.id
  security_groups = ["${aws_security_group.efs-general.id}"]
}

resource "aws_efs_file_system" "git-rails-uploads"{
          creation_token = "git-rails-uploads-efs"
          encrypted = true
          kms_key_id = aws_kms_key.git-kms.arn
          tags = {
          Name = "Git-rails-Uploads"
}
}


resource "aws_efs_mount_target" "Git-rails-uploads-Priv1" {
  file_system_id = aws_efs_file_system.git-rails-uploads.id
  subnet_id      = aws_subnet.private_subnet1.id
  security_groups = ["${aws_security_group.efs-general.id}"]
}


resource "aws_efs_mount_target" "Git-rails-uploads-Priv2" {
  file_system_id = aws_efs_file_system.git-rails-uploads.id
  subnet_id      = aws_subnet.private_subnet2.id
  security_groups = ["${aws_security_group.efs-general.id}"]
}


resource "aws_efs_file_system" "git-rails-shared"{
          creation_token = "git-rails-shared-efs"
          encrypted = true
          kms_key_id = aws_kms_key.git-kms.arn
          tags = {
          Name = "Git-rails-Shared"
}
}

resource "aws_efs_mount_target" "Git-rails-shared-Priv1" {
  file_system_id = aws_efs_file_system.git-rails-shared.id
  subnet_id      = aws_subnet.private_subnet1.id
  security_groups = ["${aws_security_group.efs-general.id}"]
}


resource "aws_efs_mount_target" "Git-rails-shared-Priv2" {
  file_system_id = aws_efs_file_system.git-rails-shared.id
  subnet_id      = aws_subnet.private_subnet2.id
  security_groups = ["${aws_security_group.efs-general.id}"]
}


resource "aws_efs_file_system" "git-builds"{
          creation_token = "git-builds-efs"
          encrypted = true
          kms_key_id = aws_kms_key.git-kms.arn
          tags = {
          Name = "Git-Builds"
}
}

resource "aws_efs_mount_target" "Git-Builds-Priv1" {
  file_system_id = aws_efs_file_system.git-builds.id
  subnet_id      = aws_subnet.private_subnet1.id
  security_groups = ["${aws_security_group.efs-general.id}"]
}


resource "aws_efs_mount_target" "Git-Builds-Priv2" {
  file_system_id = aws_efs_file_system.git-builds.id
  subnet_id      = aws_subnet.private_subnet2.id
  security_groups = ["${aws_security_group.efs-general.id}"]
}

resource "aws_efs_file_system" "git-data"{
          creation_token = "git-data-efs"
          encrypted = true
          kms_key_id = aws_kms_key.git-kms.arn
          tags = {
          Name = "Git-Data"
}
}

resource "aws_efs_mount_target" "Git-data-Priv1" {
  file_system_id = aws_efs_file_system.git-data.id
  subnet_id      = aws_subnet.private_subnet1.id
  security_groups = ["${aws_security_group.efs-general.id}"]
}

resource "aws_efs_mount_target" "Git-data-Priv2" {
  file_system_id = aws_efs_file_system.git-data.id
  subnet_id      = aws_subnet.private_subnet2.id
  security_groups = ["${aws_security_group.efs-general.id}"]
}




