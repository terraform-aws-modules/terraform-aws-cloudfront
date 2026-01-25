resource "aws_cloudfront_trust_store" "this" {
  count = var.create ? 1 : 0

  name = var.name

  ca_certificates_bundle_source {

    ca_certificates_bundle_s3_location {
      bucket  = var.ca_cert_bucket
      key     = var.ca_cert_key
      region  = var.ca_cert_region
      version = var.ca_cert_version
    }
  }

  tags = var.tags
}
