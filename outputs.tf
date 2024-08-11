output "iam_roles" {
  value = {
    sam_role_arn = aws_iam_role.deploy.arn
  }
}