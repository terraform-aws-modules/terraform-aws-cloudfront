output "cloudfront_distribution_id" {
  description = "The identifier for the distribution."
  value       = element(concat(aws_cloudfront_distribution.this.*.id, [""]), 0)
}

output "cloudfront_distribution_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution."
  value       = element(concat(aws_cloudfront_distribution.this.*.arn, [""]), 0)
}

output "cloudfront_distribution_caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
  value       = element(concat(aws_cloudfront_distribution.this.*.caller_reference, [""]), 0)
}

output "cloudfront_distribution_status" {
  description = "The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system."
  value       = element(concat(aws_cloudfront_distribution.this.*.status, [""]), 0)
}

output "cloudfront_distribution_trusted_signers" {
  description = "List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs"
  value       = element(concat(aws_cloudfront_distribution.this.*.trusted_signers, [""]), 0)
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name corresponding to the distribution."
  value       = element(concat(aws_cloudfront_distribution.this.*.domain_name, [""]), 0)
}

output "cloudfront_distribution_last_modified_time" {
  description = "The date and time the distribution was last modified."
  value       = element(concat(aws_cloudfront_distribution.this.*.last_modified_time, [""]), 0)
}

output "cloudfront_distribution_in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress."
  value       = element(concat(aws_cloudfront_distribution.this.*.in_progress_validation_batches, [""]), 0)
}

output "cloudfront_distribution_etag" {
  description = "The current version of the distribution's information."
  value       = element(concat(aws_cloudfront_distribution.this.*.etag, [""]), 0)
}

output "cloudfront_distribution_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
  value       = element(concat(aws_cloudfront_distribution.this.*.hosted_zone_id, [""]), 0)
}

output "cloudfront_origin_access_identities" {
  description = "The origin access identities created"
  value       = local.create_origin_access_identity ? { for k, v in aws_cloudfront_origin_access_identity.this : k => v } : {}
}

output "cloudfront_origin_access_identity_ids" {
  description = "The IDS of the origin access identities created"
  value       = local.create_origin_access_identity ? [for v in aws_cloudfront_origin_access_identity.this : v.id] : []
}

output "cloudfront_origin_access_identity_iam_arns" {
  description = "The IAM arns of the origin access identities created"
  value       = local.create_origin_access_identity ? [for v in aws_cloudfront_origin_access_identity.this : v.iam_arn] : []
}

output "cloudfront_monitoring_subscription_id" {
  description = " The ID of the CloudFront monitoring subscription, which corresponds to the `distribution_id`."
  value       = element(concat(aws_cloudfront_monitoring_subscription.this.*.id, [""]), 0)
}

output "cloudfront_distribution_tags" {
  description = "Tags of the distribution's"
  value       = element(concat(aws_cloudfront_distribution.this.*.tags_all, [""]), 0)
}
