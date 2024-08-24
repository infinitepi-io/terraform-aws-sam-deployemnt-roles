#############################################################################
# Cloudformation Templates Role required for SAM Deployment.
##############################################################################
resource "aws_iam_role" "deploy" {
  provider = aws.primary
  name     = var.functional_role
  path     = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "AWS" = var.gateway_role_arn
        },
        "Action" = [
          "sts:AssumeRole",
          "sts:TagSession"
        ],
      }
    ]
  })
  tags = {
    "OIDCRole" = var.gateway_role_arn
  }
}
##TODO: Adding `CompanionStack` permissions but we need to figure out why this permission required for cross account deployment.
resource "aws_iam_role_policy" "deploy" {
  provider = aws.primary
  name     = "LambdaDeploy"
  role     = aws_iam_role.deploy.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "iam:PassRole",
        "Effect" : "Allow",
        "Resource" : "arn:${var.partition}:iam::${var.account_id}:role/sam-lambda_*",
        "Sid" : "PassToLambdaRole"
      },
      {
        "Action" : [
          "cloudformation:CreateChangeSet",
          "cloudformation:DeleteStack",
          "cloudformation:DescribeChangeSet",
          "cloudformation:DescribeStackEvents",
          "cloudformation:DescribeStacks",
          "cloudformation:ExecuteChangeSet",
          "cloudformation:GetTemplate",
          "cloudformation:GetTemplateSummary"
        ],
        "Effect" : "Allow",
        "Resource" : [
          for name in var.function_names : "arn:${var.partition}:cloudformation:${var.region}:${var.account_id}:stack/${var.github_org_name}-${name}/*"
        ],
        "Sid" : "SamCloudFormation"
      },
      {
        "Action" : [
          "cloudformation:DescribeChangeSet",
          "cloudformation:DescribeStackEvents",
          "cloudformation:DescribeStacks"
        ],
        "Effect" : "Allow",
        "Resource" : [
          for name in var.function_names : "arn:${var.partition}:cloudformation:${var.region}:${var.account_id}:stack/${var.github_org_name}-${name}-????????-CompanionStack/*"
        ],
        "Sid" : "SamCloudFormationCompanionStack"
      },
      {
        "Action" : [
          "cloudformation:CreateChangeSet"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:cloudformation:us-east-1:aws:transform/Serverless-2016-10-31",
        "Sid" : "AccessToMacro"
      },
      {
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchDeleteImage",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:GetRepositoryPolicy"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "SamEcr"
      },
      {
        "Action" : [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:PutObject"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::${var.artifact_bucket_name}",
          "arn:aws:s3:::${var.artifact_bucket_name}/*"
        ],
        "Sid" : "SamS3"
      },
      {
        "Action" : [
          "lambda:*"
        ],
        "Effect" : "Allow",
        "Resource" : [
          for name in var.function_names : "arn:${var.partition}:lambda:${var.region}:${var.account_id}:function:${name}"
        ],
        "Sid" : "CloudformationLambdaPermissions"
      },
      {
        "Sid" : "CloudformationEC2Permissions",
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSecurityGroupRules",
          "ec2:DescribeTags",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
        ],
        "Resource" : "*"
      }
    ]
  })
}