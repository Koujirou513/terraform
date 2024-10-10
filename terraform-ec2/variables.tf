variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "vpc cidrblock"
}

variable "subnet_cidr" {
  type        = string
  description = "public subnet cidr"
}

