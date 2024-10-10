resource "aws_lb" "main" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [local.public_subnet_ids[0], local.public_subnet_ids[1]]

  tags = {
    Name = "My Load Balancer"
  }
}

resource "aws_lb_target_group" "go_api" {
  name        = "go-api-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "ip" # ターゲットタイプをipに変更

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "My Target Group"
  }
}

# Reactアプリ用のターゲットグループ
resource "aws_lb_target_group" "react_app" {
  name        = "react-app-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "React App Target Group"
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.react_app.arn
  }
}

# /books リクエストを go-apiに転送するルールを追加
resource "aws_lb_listener_rule" "books_rule" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.go_api.arn
  }

  condition {
    path_pattern {
      values = ["/books","/books/*"]
    }
  }
}

# go-api専用のリスナーを追加
# resource "aws_lb_listener" "go_api_listener" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 8080
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.go_api.arn
#   }
# }