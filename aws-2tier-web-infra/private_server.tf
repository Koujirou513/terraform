resource "aws_instance" "private" {
  ami                    = data.aws_ssm_parameter.latest_amazon_linux_2023.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private["private1"].id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.generated_key.key_name
  tags = {
    Name = "PrivateServer"
  }
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello, World from Private Server" > /var/www/html/index.html
              EOF
}

output "private_instance_id" {
  value = aws_instance.private.id
}

output "private_instance_private_ip" {
  value = aws_instance.private.private_ip
}

resource "aws_lb_target_group" "main" {
  name     = "main-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path = "/"
    port = "80"
  }
  tags = {
    Name = "main-target-group"
  }
}

resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.private.id
  port             = 80
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}
