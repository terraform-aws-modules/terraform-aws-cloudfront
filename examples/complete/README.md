# Complete CloudFront distribution with most of supported features enabled

Configuration in this directory creates CloudFront distribution which demos such capabilities:
- access logging
- origins and origin groups
- caching behaviours
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

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |
| random | n/a |

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

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
