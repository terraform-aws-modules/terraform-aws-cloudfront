# Upgrade from v5.x to v6.x

If you have any questions regarding this upgrade process, please consult the [`examples`](https://github.com/terraform-aws-modules/terraform-aws-cloudfront/tree/master/examples) directory:
If you find a bug, please open an issue with supporting configuration to reproduce.

## List of backwards incompatible changes

- AWS provider `v6.20` is now minimum supported version
- Support for `aws_cloudfront_origin_access_identity` has been removed in favor of `aws_cloudfront_origin_access_control`

## Additional changes

### Added

- None

### Modified

- Variable definitions now contain detailed `object` types in place of the previously used any type
- `is_ipv6_enabled` now defaults to `true` if not specified
- `default_cache_behavior.compress` and `ordered_cache_behavior.compress` now default to `true`
- `origin.origin_ssl_protocols` now defaults to `["TLSv1.2"]`
- `vpc_origin.origin_ssl_protocols.items` now defaults to `["TLSv1.2"]`
- `vpc_origin_timeouts` is now embedded under `vpc_origin`
- `viewer_certificate.minimum_protocol_version` now defaults to `"TLSv1.2_2025"`
- See the the `Before vs After` examples below for more details on variable type definition changes

### Variable and output changes

1. Removed variables:

    - `create_origin_access_identity`
    - `origin_access_identities`
    - `create_origin_access_control`
    - `create_vpc_origin`
    - `vpc_origin_timeouts` - use `timeouts` block within `vpc_origin` variable instead
    - `create_response_headers_policy`
    - `create_cloudfront_function`

2. Renamed variables:

    - `create_distribution` -> `create`

3. Added variables:

    - `anycast_ip_list_id`

4. Removed outputs:

    - `cloudfront_vpc_origin_ids`
    - `cloudfront_origin_access_controls_ids`
    - `cloudfront_origin_access_identities`
    - `cloudfront_origin_access_identity_ids`
    - `cloudfront_origin_access_identity_iam_arns`
    - `cloudfront_distribution_tags`

5. Renamed outputs:

    - None

6. Added outputs:

    - `cloudfront_vpc_origins`

## Upgrade Migrations

### Before 5.x Example

```hcl
module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws/"
  version = "~> 5.0"

  # Truncated for brevity ...

  create_vpc_origin = true
  vpc_origin = {
    ec2 = {
      arn                    = module.ec2.arn
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = {
        items    = ["TLSv1.2"]
        quantity = 1
      }
    }
  }

  vpc_origin_timeouts = {
    create = "20m"
    update = "20m"
    delete = "20m"
  }

  origin = {
    s3 = {
      domain_name = module.s3.bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }

      custom_header = [
        {
          name  = "X-Forwarded-Scheme"
          value = "https"
        },
        {
          name  = "X-Frame-Options"
          value = "SAMEORIGIN"
        }
      ]
    }
  }

  origin_group = {
    group_one = {
      failover_status_codes      = [403, 404, 500, 502]
      primary_member_origin_id   = "appsync" # Not shown
      secondary_member_origin_id = "s3"
    }
  }

  geo_restriction = {
    restriction_type = "whitelist"
    locations        = ["NO", "UA", "US", "GB"]
  }
}
```

### After 6.x Example

```hcl
module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws/"
  version = "~> 6.0"

  # Truncated for brevity ...

  vpc_origin = {
    ec2 = {
      arn                    = module.ec2.arn
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = {
        items    = ["TLSv1.2"]
        quantity = 1
      }

      timeouts = {
        create = "20m"
        update = "20m"
        delete = "20m"
      }
    }
  }

  origin = {
    s3 = {
      domain_name = module.s3.bucket_regional_domain_name
      s3_origin_config = {
        origin_access_control_key = "s3_bucket_one"
      }

      custom_header = {
        "X-Forwarded-Scheme" = "https"
        "X-Frame-Options"    = "SAMEORIGIN"
      }
    }
  }

  origin_group = {
    group-one = {
      failover_criteria = {
        status_codes = [403, 404, 500, 502]
      }
      member = [
        { origin_id = "appsync" }, # Not shown
        { origin_id = "s3" }
      ]
    }
  }

  restrictions = {
    geo_restriction = {
      restriction_type = "whitelist"
      locations        = ["NO", "UA", "US", "GB"]
    }
  }
}
```

### State Changes

None
