resource "aws_ecr_repository" "go_api" {
  name         = "go-api"
  force_delete = true
}

resource "aws_ecr_repository" "react_app" {
  name         = "react-app"
  force_delete = true
}
