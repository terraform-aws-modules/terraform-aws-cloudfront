# AWS CloudFront Terraform module

Terraform module which creates AWS CloudFront resources with all (or almost all) features provided by Terraform AWS provider.

These types of resources supported:

* [CloudFront distribution](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html)
* [CloudFront origin access itentify](https://www.terraform.io/docs/providers/aws/r/cloudfront_origin_access_identity.html)

## Terraform versions

Only Terraform 0.13 or newer is supported.

## Usage

### CloudFront distribution with versioning enabled

```hcl
module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["cdn.example.com"]

  comment             = "My awesome CloudFront"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "My awesome CloudFront can access"
  }

  logging_config = {
    bucket = "logs-my-cdn.s3.amazonaws.com"
  }

  origin = {
    something = {
      domain_name = "something.example.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1"]
      }
    }

    s3_one = {
      domain_name = "my-s3-bycket.s3.amazonaws.com"
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }
    }
  }
  
  default_cache_behavior = {
    target_origin_id       = "something"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }
  
  ordered_cache_behavior = [
    {
      path_pattern           = "/static/*"
      target_origin_id       = "s3_one"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = "arn:aws:acm:us-east-1:135367859851:certificate/1032b155-22da-4ae0-9f69-e206f825458b"
    ssl_support_method  = "sni-only"
  }
}
```

## Examples:

* [Complete](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/tree/master/examples/complete) - Complete example which creates AWS CloudFront distribution and integrates it with other [terraform-aws-modules](https://github.com/terraform-aws-modules) to create additional resources: S3 buckets, Lambda Functions, ACM Certificate, Route53 Records.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 3.28.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.28.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_cloudfront_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) |
| [aws_cloudfront_origin_access_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aliases | Extra CNAMEs (alternate domain names), if any, for this distribution. | `list(string)` | `null` | no |
| comment | Any comments you want to include about the distribution. | `string` | `null` | no |
| create\_distribution | Controls if CloudFront distribution should be created | `bool` | `true` | no |
| create\_origin\_access\_identity | Controls if CloudFront origin access identity should be created | `bool` | `false` | no |
| custom\_error\_response | One or more custom error response elements | `any` | `{}` | no |
| default\_cache\_behavior | The default cache behavior for this distribution | `any` | `null` | no |
| default\_root\_object | The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL. | `string` | `null` | no |
| enabled | Whether the distribution is enabled to accept end user requests for content. | `bool` | `true` | no |
| geo\_restriction | The restriction configuration for this distribution (geo\_restrictions) | `any` | `{}` | no |
| http\_version | The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2. | `string` | `"http2"` | no |
| is\_ipv6\_enabled | Whether the IPv6 is enabled for the distribution. | `bool` | `null` | no |
| logging\_config | The logging configuration that controls how logs are written to your distribution (maximum one). | `any` | `{}` | no |
| ordered\_cache\_behavior | An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0. | `list(any)` | `[]` | no |
| origin | One or more origins for this distribution (multiples allowed). | `any` | `null` | no |
| origin\_access\_identities | Map of CloudFront origin access identities (value as a comment) | `map(string)` | `{}` | no |
| origin\_group | One or more origin\_group for this distribution (multiples allowed). | `any` | `{}` | no |
| price\_class | The price class for this distribution. One of PriceClass\_All, PriceClass\_200, PriceClass\_100 | `string` | `null` | no |
| retain\_on\_delete | Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. | `bool` | `false` | no |
| tags | A map of tags to assign to the resource. | `map(string)` | `null` | no |
| viewer\_certificate | The SSL configuration for this distribution | `any` | <pre>{<br>  "cloudfront_default_certificate": true,<br>  "minimum_protocol_version": "TLSv1"<br>}</pre> | no |
| wait\_for\_deployment | If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process. | `bool` | `true` | no |
| web\_acl\_id | If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL. | `string` | `null` | no |

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

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko).

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.

## License

Apache 2 Licensed. See LICENSE for full details.
