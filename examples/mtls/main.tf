locals {

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
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2025"
  }

  viewer_mtls_config = {
    mode = "STRICT"
    trust_store_config = {
      trust_store_id                 = module.trust_store.id
      advertise_trust_store_ca_names = true
      ignore_certificate_expiry      = false
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "658327ea-23c6-4f73-b894-6975cd402e3b" # Managed-CachingOptimized

    response_headers_policy_id = "67f7725c-3e4c-4952-8ab4-3d18e51f9e4a" # Managed-SecurityHeadersPolicy

    function_association = {
      viewer-request = {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.example.arn
      }
    }
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

  ca_cert_bucket  = module.ca_certificates.s3_bucket_id
  ca_cert_key     = aws_s3_object.ca_certificates.key
  ca_cert_region  = "us-east-1"
  ca_cert_version = aws_s3_object.ca_certificates.version_id
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
# CloudFront Function
################################################################################

resource "aws_cloudfront_function" "example" {
  name    = "example-viewer-request"
  runtime = "cloudfront-js-2.0"
  code    = file("${path.module}/functions/viewer-request.js")
  publish = true
}
