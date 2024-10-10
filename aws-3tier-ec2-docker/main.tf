provider "aws" {
  region = "ap-northeast-1"
}

# 最新のAmazon Linux 2023 AMIを取得
data "aws_ssm_parameter" "latest_amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64" # x86_64
}