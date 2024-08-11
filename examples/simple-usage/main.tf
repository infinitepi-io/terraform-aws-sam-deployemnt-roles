#############################################################################
# Data Resource
##############################################################################
data "aws_partition" "primary" {
  provider = aws.test_aps1
}

data "aws_region" "current" {
  provider = aws.test_aps1
}
data "aws_caller_identity" "current" {
  provider = aws.test_aps1
}

resource "random_string" "sample" {
  special = false
  upper   = false
  length  = 4
}

#############################################################################
# Only Contains Data resource related to account. 
##############################################################################
data "aws_partition" "primary_test_aps1" {
  provider = aws.test_aps1
}

data "aws_region" "current_test_aps1" {
  provider = aws.test_aps1
}
data "aws_caller_identity" "current_test_aps1" {
  provider = aws.test_aps1
}
data "aws_iam_role" "gateway" {
  provider = aws.test_aps1
  name     = "github-gateway"
}

locals {
  test_aps1 = {
    partition  = data.aws_partition.primary_test_aps1.partition
    region     = data.aws_region.current_test_aps1.name
    account_id = data.aws_caller_identity.current_test_aps1.account_id
  }
  test_aps1_function_names = [
    "aws-controltower-NotificationForwarder",
  ]
}

## Prototype Development.
module "target" {
  source = "../.."
  providers = {
    aws.primary = aws.test_aps1,
  }
  artifact_bucket_name = "infinitepi-io-sam-artifacts"
  gateway_role_arn     = data.aws_iam_role.gateway.arn
  functional_role      = "deploy-${random_string.sample.id}"
  function_names       = local.test_aps1_function_names
  partition            = local.test_aps1.partition
  region               = local.test_aps1.region
  account_id           = local.test_aps1.account_id
}

output "all" {
  value = {
    target = module.target,
  }
}
