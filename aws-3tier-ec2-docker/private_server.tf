resource "aws_instance" "private" {
  count                  = 2
  ami                    = data.aws_ssm_parameter.latest_amazon_linux_2023.value
  instance_type          = var.instance_type
  subnet_id              = element([aws_subnet.private["private1"].id, aws_subnet.private["private2"].id], count.index)
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.genarated_key.key_name
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name
  tags = {
    Name = "PrivateServer-${count.index + 1}"
  }
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              sudo yum install -y git
              yum install -y docker
              sudo service docker start
              sudo usermod -a -G docker ssm-user
              sudo mkdir -p /usr/local/lib/docker/cli-plugins
              sudo curl -SL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
              sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
              sudo systemctl start docker 
              EOF
}

output "private_instance_id" {
  value = [for instance in aws_instance.private : instance.id]
}

output "private_instance_private_ip" {
  value = [for instance in aws_instance.private : instance.private_ip]
}

resource "aws_lb_target_group" "main" {
  name     = "main-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path = "/health"
    port = "8080"
  }
  tags = {
    Name = "main-target-group"
  }
}

resource "aws_lb_target_group_attachment" "main" {
  count            = length(aws_instance.private)
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = element(aws_instance.private.*.id, count.index)
  port             = 8080
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}