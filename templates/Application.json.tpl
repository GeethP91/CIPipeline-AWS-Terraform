[
 {
  "name" : "Application",
  "image" : "${REPOSITORY_URL}:latest",
  "networkMode" : "awsvpc",
  "essential" : true,
  "logConfiguration" :{
      "logDriver":"awslogs",
      "options":{
             "awslogs-group": "/ecs/Application",
             "awslogs-region": "${aws-ecr-region}",
             "awslogs-stream-prefix": "ecs"
             }
   },
   "portMappings": [
       {
        "containerPort": 22,
        "hostPort": 22
     },
     {
        "containerPort": 80,
        "hostPort": 80
       }
     ]
}
]

