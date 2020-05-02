resource "aws_alb" "Application"{
         name = "Application"
         security_groups = ["${aws_security_group.ecs.id}","${aws_security_group.alb.id}"]
         subnets = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
         internal = false
         tags = {
            Environment = "Dev"
         }
}

resource "aws_alb_target_group" "Application"{
          name = "Application"
          protocol = "HTTP"
          port = "80"
          vpc_id = aws_vpc.default.id
          target_type = "ip"
          health_check{
            path = "/"
          }
}

resource "aws_alb_listener" "Application" {
          load_balancer_arn = aws_alb.Application.arn
          port = "80"
          protocol = "HTTP"
          default_action {
            target_group_arn = aws_alb_target_group.Application.arn
            type = "forward"
          } 
          depends_on = [
          aws_alb_target_group.Application
          ]
}

output "Application_alb_dns_name" {
        value = "aws_alb.Application.dns_name"
}

