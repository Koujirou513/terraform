resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = file("${path.module}/${var.key_name}.pub")
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ssm_parameter.latest_amazon_linux_2023.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public["public1"].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated_key.key_name
  tags = {
    Name = "BastionHost"
  }
  user_data = <<-EOF
              #!/bin/bash
              yum install -y amazon-ssm-agent
              systemctl start amazon-ssm-agent
              systemctl enable amazon-ssm-agent
              EOF
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}