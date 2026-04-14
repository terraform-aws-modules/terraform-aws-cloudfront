# Example: CloudFront distribution using policy IDs with newly created CloudFront Functions
#
# Problem this solves:
# When `ordered_cache_behavior` entries reference `aws_cloudfront_function` resources that are
# being created in the same plan (i.e. their ARNs are "known after apply"), Terraform cannot
# evaluate the `for_each` on the policy name data sources at plan time:
#
#   Error: Invalid for_each argument
#   │ on .terraform/modules/cloudfront/main.tf line 542:
#   │   for_each = toset([for v in local.cache_behaviors : v.cache_policy_name if ...])
#   │ The "for_each" set includes values derived from resource attributes that
#   │ cannot be determined until apply.
#
# This happens even when no behavior sets a `*_policy_name` field, because Terraform
# treats the entire behavior object as partially unknown when any of its fields (such as
# `function_association.*.function_arn`) are unknown at plan time.
#
# Solution: set `enable_policy_name_data_sources = false` when all policies are referenced
# by ID and you need to create CloudFront Functions in the same plan as the distribution.

locals {
  origin_id = "myS3Origin"
}

# A CloudFront Function created in the same plan as the distribution.
# Its ARN is "known after apply", which would normally cause the policy data source
# for_each to fail when enable_policy_name_data_sources = true (the default).
resource "aws_cloudfront_function" "viewer_request" {
  name    = "example-viewer-request"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = <<-EOT
    function handler(event) {
      return event.request;
    }
  EOT
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "all_viewer" {
  name = "Managed-AllViewer"
}

module "cloudfront" {
  source = "../../"

  # Disable policy-name data sources because:
  # 1. All policies below are referenced by ID (not name), so name lookups are not needed.
  # 2. aws_cloudfront_function.viewer_request is created in the same plan, so its ARN is
  #    "known after apply". With enable_policy_name_data_sources = true (default), Terraform
  #    would fail to evaluate the for_each over local.cache_behaviors at plan time.
  enable_policy_name_data_sources = false

  aliases = ["mysite.example.com"]

  origin = {
    s3_origin = {
      domain_name = "example-bucket.s3.amazonaws.com"
      origin_id   = local.origin_id
    }
  }

  default_cache_behavior = {
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id
  }

  ordered_cache_behavior = [
    {
      path_pattern             = "/api/*"
      target_origin_id         = local.origin_id
      viewer_protocol_policy   = "redirect-to-https"
      cache_policy_id          = data.aws_cloudfront_cache_policy.caching_optimized.id
      origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer.id

      # This function is created in the same plan — its ARN is (known after apply).
      # With enable_policy_name_data_sources = true this would cause:
      #   "Invalid for_each argument ... cannot be determined until apply"
      function_association = {
        "viewer-request" = {
          function_arn = aws_cloudfront_function.viewer_request.arn
        }
      }
    }
  ]

  viewer_certificate = {
    cloudfront_default_certificate = true
  }
}
