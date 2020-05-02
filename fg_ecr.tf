resource "aws_ecr_repository" "application"{
         name = "application"
}

output "Application-Repo"{
       value = "${aws_ecr_repository.application.repository_url}"
}

