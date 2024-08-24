variable "artifact_bucket_name" {
  type        = string
  description = "Bucket to name to keep the sam cloudformation backup templates."
  validation {
    condition     = length(trimspace(var.artifact_bucket_name)) > 0
    error_message = "artifact_bucket_name can not be empty"
  }
}
variable "functional_role" {
  type        = string
  description = "SAM role used by Github action to deploy the lambda function"
  validation {
    condition     = can(regex("^deploy-.*", var.functional_role))
    error_message = "'functional_role' should start with deploy-"
  }
}
variable "function_names" {
  type        = list(string)
  description = "List of cloudformation template ARN"
  validation {
    condition     = length(var.function_names) > 0
    error_message = "'function_names' should be a list of functions"
  }
}
variable "gateway_role_arn" {
  type        = string
  description = "Gateway role to get into AWS."
  validation {
    condition     = can(regex("^arn:aws:iam::\\d{12}:role/.*", var.gateway_role_arn))
    error_message = "'gateway_role_arn' should start with arn:aws:iam::account_id:role:role-name"
  }
}
variable "partition" {
  type        = string
  description = "aws partition"
  validation {
    condition     = can(regex("aws|aws-cn", var.partition))
    error_message = "'partition' should be aws or aws-cn"
  }
}
variable "region" {
  type        = string
  description = "aws region"
  validation {
    condition     = length(var.region) > 0
    error_message = "'region' can not be empty."
  }
}
variable "account_id" {
  type        = string
  description = "account id where lambda is deployed"
  validation {
    condition     = can(regex("^\\d{12}$", var.account_id))
    error_message = "'account_id' should be a number"
  }
}
variable "github_org_name" {
  type        = string
  description = "github org name"
  validation {
    condition     = length(var.github_org_name) > 0
    error_message = "github_org_name can't be empty"
  }
}