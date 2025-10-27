provider "aws" {
  region = "us-east-1" # CloudFront expects ACM resources in us-east-1 region only

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false
}

locals {
  domain_name = "terraform-aws-modules.modules.tf" # trimsuffix(data.aws_route53_zone.this.name, ".")
  subdomain   = "cdn"
}

module "cloudfront" {
  source = "../../"

  aliases = ["${local.subdomain}.${local.domain_name}"]

  comment             = "My awesome CloudFront"
  enabled             = true
  staging             = false # If you want to create a staging distribution, set this to true
  http_version        = "http2and3"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  # If you want to create a primary distribution with a continuous deployment policy, set this to the ID of the policy.
  # This argument should only be set on a production distribution.
  # ref. `aws_cloudfront_continuous_deployment_policy` resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_continuous_deployment_policy
  continuous_deployment_policy_id = null

  # When you enable additional metrics for a distribution, CloudFront sends up to 8 metrics to CloudWatch in the US East (N. Virginia) Region.
  # This rate is charged only once per month, per metric (up to 8 metrics per distribution).
  create_monitoring_subscription = true

  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "My awesome CloudFront can access"
  }

  create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  create_vpc_origin = true
  vpc_origin = {
    ec2_vpc_origin = {
      name                   = random_pet.this.id
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

  logging_config = {
    bucket = module.log_bucket.s3_bucket_bucket_domain_name
    prefix = "cloudfront"
  }

  origin = {
    appsync = {
      domain_name = "appsync.${local.domain_name}"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
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

      origin_shield = {
        enabled              = true
        origin_shield_region = "us-east-1"
      }
    }

    s3_one = { # with origin access identity (legacy)
      domain_name = module.s3_one.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one" # key in `origin_access_identities`
        # cloudfront_access_identity_path = "origin-access-identity/cloudfront/E5IGQAA1QO48Z" # external OAI resource
      }
    }

    s3_oac = { # with origin access control settings (recommended)
      domain_name           = module.s3_one.s3_bucket_bucket_regional_domain_name
      origin_access_control = "s3_oac" # key in `origin_access_control`
      #      origin_access_control_id = "E345SXM82MIOSU" # external OAС resource
    }

    ec2_vpc_origin = {
      domain_name = module.ec2.private_dns
      vpc_origin_config = {
        vpc_origin = "ec2_vpc_origin" # key in `vpc_origin`
        #  vpc_origin_id  = "vo_Cg6A14otX0DB1yyDQ6Nond" # external VPC Origin resource
      }
    }
  }

  origin_group = {
    group_one = {
      failover_status_codes      = [403, 404, 500, 502]
      primary_member_origin_id   = "appsync"
      secondary_member_origin_id = "s3_one"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "appsync"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]

    use_forwarded_values = false

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
      target_origin_id       = "s3_one"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]

      use_forwarded_values = false

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

        # Option 2: Dynamic reference to module-managed function by name
        # Uncomment to use module-managed functions instead:
        # viewer-request = {
        #   function_name = "viewer-request-security"
        # }

        # viewer-response = {
        #   function_name = "viewer-response-headers"
        # }

        # For this example, using standalone function for both
        viewer-response = {
          function_arn = aws_cloudfront_function.example.arn
        }
      }
    },
    {
      path_pattern           = "/static-no-policies/*"
      target_origin_id       = "s3_one"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]

      # Using Cache/ResponseHeaders/OriginRequest policies is not allowed together with `compress` and `query_string` settings
      compress     = true
      query_string = true
    },
    {
      path_pattern           = "/vpc-origin/*"
      target_origin_id       = "ec2_vpc_origin"
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

  geo_restriction = {
    restriction_type = "whitelist"
    locations        = ["NO", "UA", "US", "GB"]
  }

  # CloudFront Functions - module managed
  create_cloudfront_function = true
  cloudfront_functions = {
    viewer-request-security = {
      runtime = "cloudfront-js-2.0"
      comment = "Security headers and cache key normalization"
      code    = file("./viewer-request-security.js")
      publish = true
    }
    viewer-response-headers = {
      runtime = "cloudfront-js-2.0"
      comment = "Add security response headers"
      code    = file("./viewer-response-headers.js")
      publish = true
    }
    ab-testing = {
      runtime = "cloudfront-js-2.0"
      comment = "A/B testing function"
      code    = file("./ab-testing.js")
      publish = true
    }
    # Example with KeyValueStore association (uncomment and provide actual KV store ARN)
    # kvstore-redirect = {
    #   runtime = "cloudfront-js-2.0"
    #   comment = "Function using CloudFront KeyValueStore for dynamic redirects"
    #   code    = file("./kvstore-redirect.js")
    #   publish = true
    #   key_value_store_associations = [
    #     "arn:aws:cloudfront::123456789012:key-value-store/example-redirects"
    #   ]
    # }
  }

  create_response_headers_policy = true
  response_headers_policies = {
    cors_policy = {
      name    = "CORSPolicy"
      comment = "CORS configuration for API"

      cors_config = {
        access_control_allow_credentials = true
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

}

######
# ACM
######

data "aws_route53_zone" "this" {
  name = local.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name               = local.domain_name
  zone_id                   = data.aws_route53_zone.this.id
  subject_alternative_names = ["${local.subdomain}.${local.domain_name}"]
}

#############
# S3 buckets
#############

data "aws_canonical_user_id" "current" {}
data "aws_cloudfront_log_delivery_canonical_user_id" "cloudfront" {}

module "s3_one" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket_prefix = "s3-one-"
  force_destroy = true
}

module "log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket_prefix = "logs-"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  grant = [{
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_canonical_user_id.current.id
    }, {
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id
    # Ref. https://github.com/terraform-providers/terraform-provider-aws/issues/12512
    # Ref. https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
  }]
  force_destroy = true
}

#############################################
# Using packaged function from Lambda module
#############################################

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

  function_name = "${random_pet.this.id}-lambda"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.11"

  publish        = true
  lambda_at_edge = true

  create_package         = false
  local_existing_package = local.downloaded

  # @todo: Missing CloudFront as allowed_triggers?

  #    allowed_triggers = {
  #      AllowExecutionFromAPIGateway = {
  #        service = "apigateway"
  #        arn     = module.api_gateway.apigatewayv2_api_execution_arn
  #      }
  #    }
}

##########
# Route53
##########

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

#########################################
# S3 bucket policy
#########################################

data "aws_iam_policy_document" "s3_policy" {
  # Origin Access Identities
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_one.s3_bucket_arn}/static/*"]

    principals {
      type        = "AWS"
      identifiers = module.cloudfront.cloudfront_origin_access_identity_iam_arns
    }
  }

  # Origin Access Controls
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_one.s3_bucket_arn}/static/*"]

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

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3_one.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}

#########################################
# CloudFront function
#########################################

resource "aws_cloudfront_function" "example" {
  name    = "example-${random_pet.this.id}"
  runtime = "cloudfront-js-1.0"
  code    = file("./example-function.js")
}

#########################################
# EC2 instance for CloudFront VPC origin
#########################################

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name = "ec2-vpc-origin-${random_pet.this.id}"
}

########
# Extra
########

resource "random_pet" "this" {
  length = 2
}
