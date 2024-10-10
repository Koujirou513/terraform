variable "region" {
  default = "ap-northeast-1"
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  default     = "my-cluster"
}

variable "service_name" {
  description = "The name of the ECS service"
  default     = "my-service"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  default     = "mydb"
}

variable "db_username" {
  description = "The username for the database"
  default     = "admin"
}

variable "db_password" {
  description = "The password for the database"
  default     = "password"
}

variable "db_instance_class" {
  description = "The instance class for the database"
  default     = "db.t3.micro"
}