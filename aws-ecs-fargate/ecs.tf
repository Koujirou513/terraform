resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

# resource "aws_ecr_repository" "react_app" {
#   name = "react-app"
# }

# resource "aws_ecr_repository" "go_api" {
#   name = "go-api"
# }

# JSONファイルを読み込むためのデータソースを定義
data "local_file" "container_definitions" {
  filename = "${path.module}/container_definitions.json"
}

resource "aws_ecs_task_definition" "main" {
  family                   = "my-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_role.arn
  container_definitions    = data.local_file.container_definitions.content

  tags = {
    ForceRedeploy = timestamp() # 現在のタイムスタンプを追加
  }
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "main" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  enable_execute_command = true

  load_balancer {
    target_group_arn = aws_lb_target_group.go_api.arn
    container_name   = "go-api"
    container_port   = 8080
  }

    load_balancer {
    target_group_arn = aws_lb_target_group.react_app.arn
    container_name   = "react-app"
    container_port   = 80
  }


  network_configuration {
    subnets          = local.public_subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

