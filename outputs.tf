################################################################################
# Distribution
################################################################################

output "cloudfront_distribution_id" {
  description = "The identifier for the distribution."
  value       = try(aws_cloudfront_distribution.this[0].id, null)
}

output "cloudfront_distribution_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution."
  value       = try(aws_cloudfront_distribution.this[0].arn, null)
}

output "cloudfront_distribution_caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
  value       = try(aws_cloudfront_distribution.this[0].caller_reference, null)
}

output "cloudfront_distribution_status" {
  description = "The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system."
  value       = try(aws_cloudfront_distribution.this[0].status, null)
}

output "cloudfront_distribution_trusted_signers" {
  description = "List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs"
  value       = try(aws_cloudfront_distribution.this[0].trusted_signers, null)
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name corresponding to the distribution."
  value       = try(aws_cloudfront_distribution.this[0].domain_name, null)
}

output "cloudfront_distribution_last_modified_time" {
  description = "The date and time the distribution was last modified."
  value       = try(aws_cloudfront_distribution.this[0].last_modified_time, null)
}

output "cloudfront_distribution_in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress."
  value       = try(aws_cloudfront_distribution.this[0].in_progress_validation_batches, null)
}

output "cloudfront_distribution_etag" {
  description = "The current version of the distribution's information."
  value       = try(aws_cloudfront_distribution.this[0].etag, null)
}

output "cloudfront_distribution_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
  value       = try(aws_cloudfront_distribution.this[0].hosted_zone_id, null)
}

################################################################################
# Origin Access Control
################################################################################

output "cloudfront_origin_access_controls" {
  description = "The origin access controls created"
  value       = aws_cloudfront_origin_access_control.this
}

################################################################################
# VPC Origin
################################################################################

output "cloudfront_vpc_origins" {
  description = "The IDS of the VPC origin created"
  value       = aws_cloudfront_vpc_origin.this
}

################################################################################
# Response Headers Policy
################################################################################

output "cloudfront_response_headers_policies" {
  description = "The response headers policies created"
  value       = aws_cloudfront_response_headers_policy.this
}

################################################################################
# Function(s)
################################################################################

output "cloudfront_functions" {
  description = "The CloudFront Functions created"
  value       = aws_cloudfront_function.this
}

################################################################################
# Monitoring Subscription
################################################################################

output "cloudfront_monitoring_subscription_id" {
  description = " The ID of the CloudFront monitoring subscription, which corresponds to the `distribution_id`."
  value       = try(aws_cloudfront_monitoring_subscription.this[0].id, null)
}
