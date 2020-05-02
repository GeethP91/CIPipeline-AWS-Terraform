data "template_file" "Application"{
      template = file("templates/Application.json.tpl")
      vars = {
         REPOSITORY_URL = aws_ecr_repository.application.repository_url
         aws-ecr-region = var.aws_region
         LOGS_GROUP = aws_cloudwatch_log_group.Application.name
      }
}

resource "aws_ecs_task_definition" "Application"{
          family = "Application"
          requires_compatibilities = ["FARGATE"]
          network_mode = "awsvpc"
          cpu = 256
          memory = 512
          container_definitions = data.template_file.Application.rendered
          execution_role_arn = aws_iam_role.ecs_task_execution.arn
          task_role_arn = aws_iam_role.ecs_task_assume.arn
}

resource "aws_ecs_service" "application-service"{
          name = "application-service"
          cluster = aws_ecs_cluster.fargate.id
          launch_type = "FARGATE"
          task_definition = aws_ecs_task_definition.Application.arn
          desired_count = 2
          network_configuration{
              subnets = [aws_subnet.private_subnet1.id,aws_subnet.private_subnet2.id]
              security_groups = ["${aws_security_group.ecs.id}"]
          }

          load_balancer {
          target_group_arn = aws_alb_target_group.Application.arn
          container_name = "Application"
          container_port = "80"
          }
          depends_on = [
          aws_alb_listener.Application
          ]
}

