# Complete CloudFront distribution with most of supported features enabled

Configuration in this directory creates CloudFront distribution which demos such capabilities:
- access logging
- origins and origin groups
- caching behaviours
- Origin Access Identities (with S3 bucket policy)
- Lambda@Edge
- ACM certificate
- Route53 record

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 3.28.0 |
| null | ~> 2 |
| random | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.28.0 |
| null | ~> 2 |
| random | ~> 2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| acm | terraform-aws-modules/acm/aws | ~> 2.0 |
| cloudfront | ../../ |  |
| lambda_function | terraform-aws-modules/lambda/aws | ~> 1.0 |
| log_bucket | terraform-aws-modules/s3-bucket/aws |  |
| records | terraform-aws-modules/route53/aws//modules/records |  |
| s3_one | terraform-aws-modules/s3-bucket/aws |  |

## Resources

| Name |
|------|
| [aws_canonical_user_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) |
| [aws_s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) |
| [null_data_source](https://registry.terraform.io/providers/hashicorp/null/latest/docs/data-sources/data_source) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| this\_cloudfront\_distribution\_arn | The ARN (Amazon Resource Name) for the distribution. |
| this\_cloudfront\_distribution\_caller\_reference | Internal value used by CloudFront to allow future updates to the distribution configuration. |
| this\_cloudfront\_distribution\_domain\_name | The domain name corresponding to the distribution. |
| this\_cloudfront\_distribution\_etag | The current version of the distribution's information. |
| this\_cloudfront\_distribution\_hosted\_zone\_id | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. |
| this\_cloudfront\_distribution\_id | The identifier for the distribution. |
| this\_cloudfront\_distribution\_in\_progress\_validation\_batches | The number of invalidation batches currently in progress. |
| this\_cloudfront\_distribution\_last\_modified\_time | The date and time the distribution was last modified. |
| this\_cloudfront\_distribution\_status | The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system. |
| this\_cloudfront\_distribution\_trusted\_signers | List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs |
| this\_cloudfront\_origin\_access\_identities | The origin access identities created |
| this\_cloudfront\_origin\_access\_identity\_iam\_arns | The IAM arns of the origin access identities created |
| this\_cloudfront\_origin\_access\_identity\_ids | The IDS of the origin access identities created |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
