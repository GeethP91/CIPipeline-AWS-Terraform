resource "aws_cloudwatch_log_group" "Application"{
          name = "/ecs/Application"
          retention_in_days = 30
          tags = {
             Name = "Application"
          }
}

resource "aws_cloudwatch_log_group" "Hello"{
         name = "/ecs/Hello"
         retention_in_days = 30
         tags = {
            Name = "Application"
         }
}

