########
# Load Balancer
########
data "aws_vpc" "default" {
  default = true
}

#All the subnets of a default vpc are public subnets
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

}

resource "aws_lb" "alb" {
  name               = "lb-tf"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.public.ids

  enable_deletion_protection = true

  tags = {
    Environment = "Demo"
  }
}


module "cloudfront" {
  source = "../../"

  enabled                       = true
  retain_on_delete              = false
  staging                       = false
  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "My awesome CloudFront can access"
  }
  default_root_object = "index.html"
  custom_error_response = [{
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 404
    response_page_path    = "/error.html"
  }]

  origin = {
    aws_lb = {
      domain_name = aws_lb.alb.dns_name
      custom_origin_config = {
        http_port = 80

      }


    }

    s3_one = {
      domain_name = module.s3_one.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }
    }
  }



  default_cache_behavior = {

    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3_one"

    query_string            = true
    query_string_cache_keys = []

    cookies_forward           = "all"
    cookies_whitelisted_names = []
    default_ttl               = 86400
    min_ttl                   = 1
    max_ttl                   = 31536000
    use_forwarded_values      = true
    viewer_protocol_policy    = "https-only"
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/v1/*"
      target_origin_id       = "aws_alb"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD"]

      headers = [
        "Authorization",
        "Origin",
      ]

      query_string            = true
      query_string_cache_keys = [] # pass empty array or don't specify this attribute at all

      cookies_forward           = "all"
      cookies_whitelisted_names = []


      use_forwarded_values = true
      default_ttl          = 0
      min_ttl              = 0
      max_ttl              = 0

    }
  ]


}

module "s3_one" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket        = "s3-one-${random_pet.this.id}"
  force_destroy = true
}
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

}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3_one.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}

########
# Extra
########

resource "random_pet" "this" {
  length = 2
}