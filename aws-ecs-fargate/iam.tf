resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole_new"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_exec_policy" {
  name        = "ecsExecPolicy"
  description = "Policy for allowing ECS Exec"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_execution_role_policy" {
  name       = "ecs-task-execution-role-policy"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
}

resource "aws_iam_policy_attachment" "ecs_exec_policy_attachment" {
  name       = "ecs-exec-policy-attachment"
  policy_arn = aws_iam_policy.ecs_exec_policy.arn
  roles      = [aws_iam_role.ecs_task_execution_role.name]
}

# 既存のECSタスク用のIAMロールを参照
data "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  role       = data.aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}