variable "vpc_cidr" {
  description = "VPC CIDRブロック"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "パブリックサブネットCIDRブロックのリスト"
  type        = map(string)
  default = {
    subnet1 = "10.0.1.0/24"
    subnet2 = "10.0.4.0/24"
  }
}

variable "private_subnet_cidrs" {
  description = "プライベートサブネットのCIDRブロックのリスト"
  type        = map(string)
  default = {
    subnet1 = "10.0.2.0/24"
    subnet2 = "10.0.3.0/24"
    subnet3 = "10.0.5.0/24"
    subnet4 = "10.0.6.0/24"
  }
}

variable "allowed_ssh_cidr" {
  description = "SSHアクセスを許可するCIDRブロック"
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  description = "EC2インスタンスタイプ"
  default     = "t2.micro"
}

variable "key_name" {
  description = "ec2-keypair"
}