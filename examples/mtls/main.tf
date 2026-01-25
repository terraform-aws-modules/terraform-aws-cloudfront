locals {
  subdomain = "cdn"

  name = "ex-${basename(path.cwd)}"

  tags = {
    Test       = local.name
    GithubRepo = "terraform-aws-cloudfront"
    GithubOrg  = "terraform-aws-modules"
  }
}

provider "aws" {
  region = "us-east-1"
}

################################################################################
# CloudFront Distribution with mTLS
################################################################################

module "cloudfront" {
  source = "../../"

  enabled             = true
  comment             = "CloudFront distribution with mTLS"
  default_root_object = "index.html"

  viewer_certificate = {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  viewer_mtls_config = {
    mode = "required"
    trust_store_config = {
      trust_store_id                 = module.trust_store.id
      advertise_trust_store_ca_names = true
      ignore_certificate_expiry      = false
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3"
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized

    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
  }

  origin_access_control = {
    s3 = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    s3 = {
      domain_name               = module.s3.s3_bucket_bucket_regional_domain_name
      origin_access_control_key = "s3" # key in `origin_access_control`
    }
  }

  restrictions = {
    geo_restriction = {
      restriction_type = "none"
    }
  }

  # Connection Function Configuration
  # The default service quota is zero so a quota limit increase request is required to make use of them
  # create_connection_function = true
  # connection_function_name   = "example-connection-function"
  # connection_function_code   = file("${path.module}/functions/connection.js")
  # connection_function_config = {
  #   comment = "Example connection function for mTLS distribution"
  #   runtime = "cloudfront-js-2.0"
  # }
}

################################################################################
# TLS Certificates for mTLS
################################################################################

resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "Example CA"
    organization = "Example Inc"
  }

  validity_period_hours = 8760
  is_ca_certificate     = true

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
  ]
}

resource "tls_private_key" "client" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "client" {
  private_key_pem = tls_private_key.client.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "Example Inc"
  }
}

resource "tls_locally_signed_cert" "client" {
  cert_request_pem   = tls_cert_request.client.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 24
  is_ca_certificate     = false

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
  ]
}

################################################################################
# S3 Bucket for CA Certificates
################################################################################

module "ca_certificates" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket_prefix = "${local.name}-ca-certs-"

  # For example only
  force_destroy = true

  tags = local.tags
}

resource "aws_s3_object" "ca_certificates" {
  bucket       = module.ca_certificates.s3_bucket_id
  key          = "ca-bundle.pem"
  content      = tls_self_signed_cert.ca.cert_pem
  content_type = "application/x-pem-file"
}

#####################################################################
# Random ID for unique bucket name
###########################################################

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

################################################################################
# Trust Store
################################################################################

module "trust_store" {
  source = "../../modules/trust_store"

  name = "example-mtls-trust-store"

  ca_cert_bucket = module.ca_certificates.s3_bucket_id
  ca_cert_key    = aws_s3_object.ca_certificates.key
  ca_cert_region = "us-east-1"

  tags = local.tags
}

################################################################################
# S3 Bucket for CloudFront Origin
################################################################################

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

resource "aws_s3_object" "this" {
  bucket       = module.s3.s3_bucket_id
  key          = "index.html"
  source       = "${path.module}/index.html"
  etag         = filemd5("${path.module}/index.html")
  content_type = "text/html"
}

#####################################################################
# Random ID for unique bucket name
###########################################################

resource "random_id" "example_suffix" {
  byte_length = 4
}

################################################################################
# ACM
################################################################################

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
