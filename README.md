# AWS CloudFront Terraform module

Terraform module which creates AWS CloudFront resources with all (or almost all) features provided by Terraform AWS provider.

## Usage

### CloudFront distribution with versioning enabled

```hcl
module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["cdn.example.com"]
  comment = "My awesome CloudFront"

  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
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
        origin_ssl_protocols   = ["TLSv1.2"]
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
      target_origin_id       = "s3"
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

### CloudFront distribution with CloudFront Functions

```hcl
module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["cdn.example.com"]
  comment = "CloudFront with Functions"

  origin_access_control = {
    s3 = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  # Enable CloudFront Functions
  cloudfront_functions = {
    viewer-request-function = {
      runtime = "cloudfront-js-2.0"
      comment = "Function to add security headers and modify requests"
      code    = file("${path.module}/functions/viewer-request.js")
      publish = true
    }

    viewer-response-function = {
      runtime = "cloudfront-js-2.0"
      comment = "Function to add security response headers"
      code    = file("${path.module}/functions/viewer-response.js")
      publish = true
      # Optional: Associate with CloudFront KeyValueStore
      key_value_store_associations = ["arn:aws:cloudfront::123456789012:key-value-store/example-store"]
    }
  }

  origin = {
    s3_bucket = {
      domain_name = "my-bucket.s3.amazonaws.com"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_bucket"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true

    # Associate CloudFront Functions with cache behavior
    # Option 1: Direct ARN reference (recommended for external functions)
    # function_association = {
    #   viewer-request = {
    #     function_arn = aws_cloudfront_function.external.arn
    #   }
    # }

    # Option 2: Dynamic reference to module-managed functions by key/name
    function_association = {
      viewer-request = {
        function_key = "viewer-request-function"
      }
      viewer-response = {
        function_key = "viewer-response-function"
      }
    }
  }

  viewer_certificate = {
    acm_certificate_arn = "arn:aws:acm:us-east-1:135367859851:certificate/1032b155-22da-4ae0-9f69-e206f825458b"
    ssl_support_method  = "sni-only"
  }
}
```

## Examples

- [Complete](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/tree/master/examples/complete) - Complete example which creates AWS CloudFront distribution and integrates it with other [terraform-aws-modules](https://github.com/terraform-aws-modules) to create additional resources: S3 buckets, Lambda Functions, CloudFront Functions, VPC Origins, ACM Certificate, Route53 Records.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.20 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function) | resource |
| [aws_cloudfront_monitoring_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_monitoring_subscription) | resource |
| [aws_cloudfront_origin_access_control.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_cloudfront_response_headers_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_response_headers_policy) | resource |
| [aws_cloudfront_vpc_origin.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_vpc_origin) | resource |
| [aws_cloudfront_cache_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy) | data source |
| [aws_cloudfront_origin_request_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_origin_request_policy) | data source |
| [aws_cloudfront_response_headers_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_response_headers_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Extra CNAMEs (alternate domain names), if any, for this distribution | `list(string)` | `null` | no |
| <a name="input_anycast_ip_list_id"></a> [anycast\_ip\_list\_id](#input\_anycast\_ip\_list\_id) | ID of the Anycast static IP list that is associated with the distribution | `string` | `null` | no |
| <a name="input_cloudfront_functions"></a> [cloudfront\_functions](#input\_cloudfront\_functions) | Map of CloudFront Function configurations. Key is used as default function name if 'name' not specified | <pre>map(object({<br/>    name                         = optional(string)<br/>    runtime                      = optional(string, "cloudfront-js-2.0")<br/>    comment                      = optional(string)<br/>    publish                      = optional(bool)<br/>    code                         = string<br/>    key_value_store_associations = optional(list(string))<br/>  }))</pre> | `null` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Any comments you want to include about the distribution | `string` | `null` | no |
| <a name="input_continuous_deployment_policy_id"></a> [continuous\_deployment\_policy\_id](#input\_continuous\_deployment\_policy\_id) | Identifier of a continuous deployment policy. This argument should only be set on a production distribution | `string` | `null` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created (affects nearly all resources) | `bool` | `true` | no |
| <a name="input_create_monitoring_subscription"></a> [create\_monitoring\_subscription](#input\_create\_monitoring\_subscription) | If enabled, the resource for monitoring subscription will created | `bool` | `false` | no |
| <a name="input_custom_error_response"></a> [custom\_error\_response](#input\_custom\_error\_response) | One or more custom error response elements | <pre>list(object({<br/>    error_caching_min_ttl = optional(number)<br/>    error_code            = number<br/>    response_code         = optional(number)<br/>    response_page_path    = optional(string)<br/>  }))</pre> | `null` | no |
| <a name="input_default_cache_behavior"></a> [default\_cache\_behavior](#input\_default\_cache\_behavior) | The default cache behavior for this distribution | <pre>object({<br/>    allowed_methods           = optional(list(string), ["GET", "HEAD", "OPTIONS"])<br/>    cache_policy_id           = optional(string)<br/>    cache_policy_name         = optional(string)<br/>    cached_methods            = optional(list(string), ["GET", "HEAD"])<br/>    compress                  = optional(bool, true)<br/>    default_ttl               = optional(number)<br/>    field_level_encryption_id = optional(string)<br/>    forwarded_values = optional(object({<br/>      cookies = object({<br/>        forward           = optional(string, "none")<br/>        whitelisted_names = optional(list(string))<br/>      })<br/>      headers                 = optional(list(string))<br/>      query_string            = optional(bool, false)<br/>      query_string_cache_keys = optional(list(string))<br/>      }),<br/>      {<br/>        cookies = {<br/>          forward = "none"<br/>        }<br/>        query_string = false<br/>      }<br/>    )<br/>    function_association = optional(map(object({<br/>      event_type   = optional(string)<br/>      function_arn = optional(string)<br/>      function_key = optional(string)<br/>    })))<br/>    grpc_config = optional(object({<br/>      enabled = optional(bool)<br/>    }))<br/>    lambda_function_association = optional(map(object({<br/>      event_type   = optional(string)<br/>      include_body = optional(bool)<br/>      lambda_arn   = string<br/>    })))<br/>    max_ttl                      = optional(number)<br/>    min_ttl                      = optional(number)<br/>    origin_request_policy_id     = optional(string)<br/>    origin_request_policy_name   = optional(string)<br/>    realtime_log_config_arn      = optional(string)<br/>    response_headers_policy_id   = optional(string)<br/>    response_headers_policy_name = optional(string)<br/>    smooth_streaming             = optional(bool)<br/>    target_origin_id             = string<br/>    trusted_key_groups           = optional(list(string))<br/>    trusted_signers              = optional(list(string))<br/>    viewer_protocol_policy       = optional(string, "https-only")<br/>  })</pre> | n/a | yes |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the distribution is enabled to accept end user requests for content | `bool` | `true` | no |
| <a name="input_http_version"></a> [http\_version](#input\_http\_version) | The maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3, and http3. The default is http2 | `string` | `"http2"` | no |
| <a name="input_is_ipv6_enabled"></a> [is\_ipv6\_enabled](#input\_is\_ipv6\_enabled) | Whether the IPv6 is enabled for the distribution | `bool` | `true` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | The logging configuration that controls how logs are written to your distribution (maximum one) | <pre>object({<br/>    bucket          = optional(string)<br/>    include_cookies = optional(bool)<br/>    prefix          = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_ordered_cache_behavior"></a> [ordered\_cache\_behavior](#input\_ordered\_cache\_behavior) | An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0 | <pre>list(object({<br/>    allowed_methods           = optional(list(string), ["GET", "HEAD", "OPTIONS"])<br/>    cached_methods            = optional(list(string), ["GET", "HEAD"])<br/>    cache_policy_id           = optional(string)<br/>    cache_policy_name         = optional(string)<br/>    compress                  = optional(bool, true)<br/>    default_ttl               = optional(number)<br/>    field_level_encryption_id = optional(string)<br/>    forwarded_values = optional(object({<br/>      cookies = object({<br/>        forward           = optional(string, "none")<br/>        whitelisted_names = optional(list(string))<br/>      })<br/>      headers                 = optional(list(string))<br/>      query_string            = optional(bool, false)<br/>      query_string_cache_keys = optional(list(string))<br/>      }),<br/>      {<br/>        cookies = {<br/>          forward = "none"<br/>        }<br/>        query_string = false<br/>      }<br/>    )<br/>    function_association = optional(map(object({<br/>      event_type   = optional(string)<br/>      function_arn = optional(string)<br/>      function_key = optional(string)<br/>    })))<br/>    grpc_config = optional(object({<br/>      enabled = optional(bool)<br/>    }))<br/>    lambda_function_association = optional(map(object({<br/>      event_type   = optional(string)<br/>      include_body = optional(bool)<br/>      lambda_arn   = string<br/>    })))<br/>    max_ttl                      = optional(number)<br/>    min_ttl                      = optional(number)<br/>    origin_request_policy_id     = optional(string)<br/>    origin_request_policy_name   = optional(string)<br/>    path_pattern                 = string<br/>    realtime_log_config_arn      = optional(string)<br/>    response_headers_policy_id   = optional(string)<br/>    response_headers_policy_name = optional(string)<br/>    smooth_streaming             = optional(bool)<br/>    target_origin_id             = string<br/>    trusted_key_groups           = optional(list(string))<br/>    trusted_signers              = optional(list(string))<br/>    viewer_protocol_policy       = string<br/>  }))</pre> | `[]` | no |
| <a name="input_origin"></a> [origin](#input\_origin) | One or more origins for this distribution (multiples allowed) | <pre>map(object({<br/>    connection_attempts = optional(number)<br/>    connection_timeout  = optional(number)<br/>    custom_header       = optional(map(string))<br/>    custom_origin_config = optional(object({<br/>      http_port                = number<br/>      https_port               = number<br/>      ip_address_type          = optional(string)<br/>      origin_keepalive_timeout = optional(number)<br/>      origin_read_timeout      = optional(number)<br/>      origin_protocol_policy   = string<br/>      origin_ssl_protocols     = optional(list(string), ["TLSv1.2"])<br/>    }))<br/>    domain_name               = string<br/>    origin_access_control_key = optional(string)<br/>    origin_access_control_id  = optional(string)<br/>    origin_id                 = optional(string)<br/>    origin_path               = optional(string)<br/>    origin_shield = optional(object({<br/>      enabled              = bool<br/>      origin_shield_region = optional(string)<br/>    }))<br/>    response_completion_timeout = optional(number)<br/>    vpc_origin_config = optional(object({<br/>      origin_keepalive_timeout = optional(number)<br/>      origin_read_timeout      = optional(number)<br/>      vpc_origin_id            = optional(string)<br/>      vpc_origin_key           = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_origin_access_control"></a> [origin\_access\_control](#input\_origin\_access\_control) | Map of CloudFront origin access control | <pre>map(object({<br/>    description      = optional(string)<br/>    name             = optional(string)<br/>    origin_type      = string<br/>    signing_behavior = string<br/>    signing_protocol = string<br/>  }))</pre> | <pre>{<br/>  "s3": {<br/>    "origin_type": "s3",<br/>    "signing_behavior": "always",<br/>    "signing_protocol": "sigv4"<br/>  }<br/>}</pre> | no |
| <a name="input_origin_group"></a> [origin\_group](#input\_origin\_group) | One or more origin\_group for this distribution (multiples allowed) | <pre>map(object({<br/>    failover_criteria = object({<br/>      status_codes = list(number)<br/>    })<br/>    member = list(object({<br/>      origin_id = string<br/>    }))<br/>    origin_id = optional(string)<br/>  }))</pre> | `null` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | The price class for this distribution. One of `PriceClass_All`, `PriceClass_200`, `PriceClass_100` | `string` | `null` | no |
| <a name="input_realtime_metrics_subscription_status"></a> [realtime\_metrics\_subscription\_status](#input\_realtime\_metrics\_subscription\_status) | A flag that indicates whether additional CloudWatch metrics are enabled for a given CloudFront distribution. Valid values are `Enabled` and `Disabled` | `string` | `"Enabled"` | no |
| <a name="input_response_headers_policies"></a> [response\_headers\_policies](#input\_response\_headers\_policies) | Map of CloudFront response headers policies with their configurations | <pre>map(object({<br/>    name    = optional(string)<br/>    comment = optional(string)<br/>    cors_config = optional(object({<br/>      access_control_allow_credentials = bool<br/>      origin_override                  = bool<br/>      access_control_allow_headers = object({<br/>        items = list(string)<br/>      })<br/>      access_control_allow_methods = object({<br/>        items = list(string)<br/>      })<br/>      access_control_allow_origins = object({<br/>        items = list(string)<br/>      })<br/>      access_control_expose_headers = optional(object({<br/>        items = list(string)<br/>      }))<br/>      access_control_max_age_sec = optional(number)<br/>    }))<br/>    custom_headers_config = optional(object({<br/>      items = list(object({<br/>        header   = string<br/>        override = bool<br/>        value    = string<br/>      }))<br/>    }))<br/>    remove_headers_config = optional(object({<br/>      items = list(object({<br/>        header = string<br/>      }))<br/>    }))<br/>    security_headers_config = optional(object({<br/>      content_security_policy = optional(object({<br/>        content_security_policy = string<br/>        override                = bool<br/>      }))<br/>      content_type_options = optional(object({<br/>        override = bool<br/>      }))<br/>      frame_options = optional(object({<br/>        frame_option = string<br/>        override     = bool<br/>      }))<br/>      referrer_policy = optional(object({<br/>        referrer_policy = string<br/>        override        = bool<br/>      }))<br/>      strict_transport_security = optional(object({<br/>        access_control_max_age_sec = number<br/>        override                   = bool<br/>        include_subdomains         = optional(bool)<br/>        preload                    = optional(bool)<br/>      }))<br/>      xss_protection = optional(object({<br/>        mode_block = bool<br/>        override   = bool<br/>        protection = bool<br/>        report_uri = optional(string)<br/>      }))<br/>    }))<br/>    server_timing_headers_config = optional(object({<br/>      enabled       = bool<br/>      sampling_rate = number<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_restrictions"></a> [restrictions](#input\_restrictions) | The restrictions configuration for this distribution | <pre>object({<br/>    geo_restriction = object({<br/>      locations        = optional(list(string))<br/>      restriction_type = optional(string, "none")<br/>    })<br/>  })</pre> | <pre>{<br/>  "geo_restriction": {<br/>    "restriction_type": "none"<br/>  }<br/>}</pre> | no |
| <a name="input_retain_on_delete"></a> [retain\_on\_delete](#input\_retain\_on\_delete) | Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards | `bool` | `null` | no |
| <a name="input_staging"></a> [staging](#input\_staging) | Whether the distribution is a staging distribution | `bool` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_viewer_certificate"></a> [viewer\_certificate](#input\_viewer\_certificate) | The SSL configuration for this distribution | <pre>object({<br/>    acm_certificate_arn            = optional(string)<br/>    cloudfront_default_certificate = optional(bool)<br/>    iam_certificate_id             = optional(string)<br/>    minimum_protocol_version       = optional(string, "TLSv1.2_2025")<br/>    ssl_support_method             = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_vpc_origin"></a> [vpc\_origin](#input\_vpc\_origin) | Map of CloudFront VPC origins | <pre>map(object({<br/>    arn                    = string<br/>    http_port              = number<br/>    https_port             = number<br/>    name                   = optional(string)<br/>    origin_protocol_policy = string<br/>    origin_ssl_protocols = object({<br/>      items    = optional(list(string), ["TLSv1.2"])<br/>      quantity = optional(number, 1)<br/>    })<br/>    timeouts = optional(object({<br/>      create = optional(string)<br/>      update = optional(string)<br/>      delete = optional(string)<br/>    }))<br/>    tags = optional(map(string), {})<br/>  }))</pre> | `null` | no |
| <a name="input_wait_for_deployment"></a> [wait\_for\_deployment](#input\_wait\_for\_deployment) | If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this to false will skip the process | `bool` | `null` | no |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | The ARN (Amazon Resource Name) for the distribution. |
| <a name="output_cloudfront_distribution_caller_reference"></a> [cloudfront\_distribution\_caller\_reference](#output\_cloudfront\_distribution\_caller\_reference) | Internal value used by CloudFront to allow future updates to the distribution configuration. |
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront\_distribution\_domain\_name](#output\_cloudfront\_distribution\_domain\_name) | The domain name corresponding to the distribution. |
| <a name="output_cloudfront_distribution_etag"></a> [cloudfront\_distribution\_etag](#output\_cloudfront\_distribution\_etag) | The current version of the distribution's information. |
| <a name="output_cloudfront_distribution_hosted_zone_id"></a> [cloudfront\_distribution\_hosted\_zone\_id](#output\_cloudfront\_distribution\_hosted\_zone\_id) | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The identifier for the distribution. |
| <a name="output_cloudfront_distribution_in_progress_validation_batches"></a> [cloudfront\_distribution\_in\_progress\_validation\_batches](#output\_cloudfront\_distribution\_in\_progress\_validation\_batches) | The number of invalidation batches currently in progress. |
| <a name="output_cloudfront_distribution_last_modified_time"></a> [cloudfront\_distribution\_last\_modified\_time](#output\_cloudfront\_distribution\_last\_modified\_time) | The date and time the distribution was last modified. |
| <a name="output_cloudfront_distribution_status"></a> [cloudfront\_distribution\_status](#output\_cloudfront\_distribution\_status) | The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system. |
| <a name="output_cloudfront_distribution_trusted_signers"></a> [cloudfront\_distribution\_trusted\_signers](#output\_cloudfront\_distribution\_trusted\_signers) | List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs |
| <a name="output_cloudfront_functions"></a> [cloudfront\_functions](#output\_cloudfront\_functions) | The CloudFront Functions created |
| <a name="output_cloudfront_monitoring_subscription_id"></a> [cloudfront\_monitoring\_subscription\_id](#output\_cloudfront\_monitoring\_subscription\_id) | The ID of the CloudFront monitoring subscription, which corresponds to the `distribution_id`. |
| <a name="output_cloudfront_origin_access_controls"></a> [cloudfront\_origin\_access\_controls](#output\_cloudfront\_origin\_access\_controls) | The origin access controls created |
| <a name="output_cloudfront_response_headers_policies"></a> [cloudfront\_response\_headers\_policies](#output\_cloudfront\_response\_headers\_policies) | The response headers policies created |
| <a name="output_cloudfront_vpc_origins"></a> [cloudfront\_vpc\_origins](#output\_cloudfront\_vpc\_origins) | The IDS of the VPC origin created |
<!-- END_TF_DOCS -->

## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from these awesome contributors:

<!-- markdownlint-disable no-inline-html -->
<a href="https://github.com/terraform-aws-modules/terraform-aws-cloudfront/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=terraform-aws-modules/terraform-aws-cloudfront" />
</a>
<!-- markdownlint-enable no-inline-html -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/tree/master/LICENSE) for full details.
