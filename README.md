# terraform-aws-sam-deployemnt-roles

Module to create github action functional_role for lambda deployment. 

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= 1.0  |
| aws       | >= 5.0  |

## Providers

| Name        | Version |
| ----------- | ------- |
| aws.primary | >= 5.0  |

## Resources

| Name                                                         | Type     |
| ------------------------------------------------------------ | -------- |
| [aws_iam_role.deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name                   | Description                                                  | Type           | Default | Required |
| ---------------------- | ------------------------------------------------------------ | -------------- | ------- | :------: |
| account\_id            | account id where lambda is deployed                          | `string`       | n/a     |   yes    |
| artifact\_bucket\_name | Bucket to name to keep the sam cloudformation backup templates. | `string`       | n/a     |   yes    |
| function\_names        | List of cloudformation template ARN                          | `list(string)` | n/a     |   yes    |
| functional\_role       | SAM role used by Github action to deploy the lambda function | `string`       | n/a     |   yes    |
| gateway\_role\_arn     | Gateway role to get into AWS.                                | `string`       | n/a     |   yes    |
| partition              | aws partition                                                | `string`       | n/a     |   yes    |
| region                 | aws region                                                   | `string`       | n/a     |   yes    |

## Outputs

| Name       | Description |
| ---------- | ----------- |
| iam\_roles | n/a         |

<!-- END_TF_DOCS -->
