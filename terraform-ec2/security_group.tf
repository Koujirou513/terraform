resource "aws_security_group" "sg" {
  name        = "${var.project}-${var.environment}-sg"
  description = "security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "${var.project}-${var.environment}-sg"
    Project = var.project
    Env     = var.environment
  }
}
