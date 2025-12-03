provider "aws" {
  region = "us-east-1" # CloudFront expects ACM resources in us-east-1 region only
}

data "aws_availability_zones" "available" {
  # Exclude local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  subdomain = "cdn"

  name = "ex-${basename(path.cwd)}"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Test       = local.name
    GithubRepo = "terraform-aws-cloudfront"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# CloudFront Module
################################################################################

module "cloudfront" {
  source = "../../"

  aliases = ["${local.subdomain}.${var.domain}"]

  comment         = "My awesome CloudFront"
  enabled         = true
  http_version    = "http2and3"
  is_ipv6_enabled = true
  price_class     = "PriceClass_All"

  create_monitoring_subscription = true

  logging_config = {
    bucket = module.log_bucket.s3_bucket_bucket_domain_name
    prefix = "cloudfront"
  }

  origin_access_control = {
    s3 = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

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
    appsync = {
      domain_name = "appsync.${var.domain}"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }

      custom_header = {
        "X-Forwarded-Scheme" = "https"
        "X-Frame-Options"    = "SAMEORIGIN"
      }

      origin_shield = {
        enabled              = true
        origin_shield_region = "us-east-1"
      }
    }

    s3 = {
      domain_name               = module.s3.s3_bucket_bucket_regional_domain_name
      origin_access_control_key = "s3" # key in `origin_access_control`
      # origin_access_control_id  = "E345SXM82MIOSU" # external OAС resource
    }

    ec2 = {
      domain_name = module.ec2.private_dns
      vpc_origin_config = {
        vpc_origin_key = "ec2" # key in `vpc_origin`
        # vpc_origin_id  = "vo_Cg6A14otX0DB1yyDQ6Nond" # external VPC Origin resource
      }
    }
  }

  origin_group = {
    group_one = {
      failover_criteria = {
        status_codes = [403, 404, 500, 502]
      }
      member = [
        { origin_id = "appsync" },
        { origin_id = "s3" }
      ]
    }
  }

  default_cache_behavior = {
    target_origin_id       = "appsync"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]

    cache_policy_id            = "b2884449-e4de-46a7-ac36-70bc7f1ddd6d"
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"

    lambda_function_association = {
      # Valid keys: viewer-request, origin-request, viewer-response, origin-response
      viewer-request = {
        lambda_arn   = module.lambda_function.lambda_function_qualified_arn
        include_body = true
      }

      origin-request = {
        lambda_arn = module.lambda_function.lambda_function_qualified_arn
      }
    }
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/static/*"
      target_origin_id       = "s3"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]

      cache_policy_name            = "Managed-CachingOptimized"
      origin_request_policy_name   = "Managed-UserAgentRefererHeaders"
      response_headers_policy_name = "Managed-SimpleCORS"
      # using a response header policy you're dynamically creating below
      # response_header_policy: "cors_policy"

      function_association = {
        # Valid keys: viewer-request, viewer-response

        # Option 1: Direct ARN reference to standalone resource
        viewer-request = {
          function_arn = aws_cloudfront_function.example.arn
        }

        # Option 2: Dynamic reference to module-managed function by key/name
        # Uncomment to use module-managed functions instead:
        # viewer-request = {
        #   function_key = "viewer-request-security"
        # }

        # viewer-response = {
        #   function_key = "viewer-response-headers"
        # }

        # For this example, using standalone function for both
        viewer-response = {
          function_arn = aws_cloudfront_function.example.arn
        }
      }
    },
    {
      path_pattern           = "/static-no-policies/*"
      target_origin_id       = "s3"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]

      # Using Cache/ResponseHeaders/OriginRequest policies is not allowed together with `compress` and `query_string` settings
      compress     = true
      query_string = true
    },
    {
      path_pattern           = "/vpc-origin/*"
      target_origin_id       = "ec2"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  custom_error_response = [{
    error_code         = 404
    response_code      = 404
    response_page_path = "/errors/404.html"
    }, {
    error_code         = 403
    response_code      = 403
    response_page_path = "/errors/403.html"
  }]

  restrictions = {
    geo_restriction = {
      restriction_type = "whitelist"
      locations        = ["NO", "UA", "US", "GB"]
    }
  }

  # CloudFront Functions - module managed
  cloudfront_functions = {
    viewer-request-security = {
      runtime = "cloudfront-js-2.0"
      comment = "Security headers and cache key normalization"
      code    = file("./functions/viewer-request-security.js")
      publish = true
    }
    viewer-response-headers = {
      runtime = "cloudfront-js-2.0"
      comment = "Add security response headers"
      code    = file("./functions/viewer-response-headers.js")
      publish = true
    }
    ab-testing = {
      runtime = "cloudfront-js-2.0"
      comment = "A/B testing function"
      code    = file("./functions/ab-testing.js")
      publish = true
    }
    # Example with KeyValueStore association (uncomment and provide actual KV store ARN)
    # kvstore-redirect = {
    #   runtime = "cloudfront-js-2.0"
    #   comment = "Function using CloudFront KeyValueStore for dynamic redirects"
    #   code    = file("./functions/kvstore-redirect.js")
    #   publish = true
    #   key_value_store_associations = [
    #     "arn:aws:cloudfront::123456789012:key-value-store/example-redirects"
    #   ]
    # }
  }

  response_headers_policies = {
    cors_policy = {
      name    = "CORSPolicy"
      comment = "CORS configuration for API"

      cors_config = {
        access_control_allow_credentials = false
        origin_override                  = true

        access_control_allow_headers = {
          items = ["*"]
        }

        access_control_allow_methods = {
          items = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
        }

        access_control_allow_origins = {
          items = ["https://example.com", "https://app.example.com"]
        }

        access_control_expose_headers = {
          items = ["X-Custom-Header", "X-Request-Id"]
        }

        access_control_max_age_sec = 3600
      }
    }
    custom_headers = {
      name    = "CustomHeadersPolicy"
      comment = "Add custom response headers"

      custom_headers_config = {
        items = [
          {
            header   = "X-Powered-By"
            override = true
            value    = "MyApp/1.0"
          },
          {
            header   = "X-API-Version"
            override = false
            value    = "v2"
          },
          {
            header   = "Cache-Control"
            override = true
            value    = "public, max-age=3600"
          }
        ]
      }
    }
    remove_headers = {
      name    = "RemoveHeadersPolicy"
      comment = "Remove unwanted headers from origin"

      remove_headers_config = {
        items = [
          {
            header = "x-robots-tag"
          },
          {
            header = "server"
          },
          {
            header = "x-powered-by"
          }
        ]
      }
    }
  }

  tags = local.tags
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 5.0"

  zone_id = data.aws_route53_zone.this.zone_id

  records = [
    {
      name = local.subdomain
      type = "A"
      alias = {
        name    = module.cloudfront.cloudfront_distribution_domain_name
        zone_id = module.cloudfront.cloudfront_distribution_hosted_zone_id
      }
    },
  ]
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name      = local.name
  subnet_id = element(module.vpc.private_subnets, 0)
}

resource "aws_cloudfront_function" "example" {
  name    = local.name
  runtime = "cloudfront-js-1.0"
  code    = file("./functions/example-function.js")
}

data "aws_route53_zone" "this" {
  name = var.domain
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name               = var.domain
  zone_id                   = data.aws_route53_zone.this.id
  subject_alternative_names = ["${local.subdomain}.${var.domain}"]

  tags = local.tags
}

module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket_prefix = "${local.name}-"

  # For example only
  force_destroy = true

  attach_policy = true
  policy        = data.aws_iam_policy_document.s3_policy.json

  tags = local.tags
}

data "aws_iam_policy_document" "s3_policy" {
  # Origin Access Control
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }
}

data "aws_canonical_user_id" "current" {}
data "aws_cloudfront_log_delivery_canonical_user_id" "cloudfront" {}

module "log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket_prefix = "${local.name}-logs-"

  # For example only
  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  grant = [
    {
      type       = "CanonicalUser"
      permission = "FULL_CONTROL"
      id         = data.aws_canonical_user_id.current.id
    },
    {
      type       = "CanonicalUser"
      permission = "FULL_CONTROL"
      id         = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id
      # Ref. https://github.com/terraform-providers/terraform-provider-aws/issues/12512
      # Ref. https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
    }
  ]

  tags = local.tags
}

################################################################################
# Using packaged function from Lambda module
################################################################################

locals {
  package_url = "https://raw.githubusercontent.com/terraform-aws-modules/terraform-aws-lambda/master/examples/fixtures/python-zip/existing_package.zip"
  downloaded  = "downloaded_package_${md5(local.package_url)}.zip"
}

resource "null_resource" "download_package" {
  triggers = {
    downloaded = local.downloaded
  }

  provisioner "local-exec" {
    command = "curl -L -o ${local.downloaded} ${local.package_url}"
  }
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 8.0"

  function_name = local.name
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.11"

  publish        = true
  lambda_at_edge = true

  create_package         = false
  local_existing_package = local.downloaded
}
