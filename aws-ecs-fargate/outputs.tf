output "cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.main.arn
}

output "service_name" {
  value = aws_ecs_service.main.name
}

output "load_balancer_dns" {
  value = aws_lb.main.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}