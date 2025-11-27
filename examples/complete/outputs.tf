################################################################################
# Distribution
################################################################################

output "cloudfront_distribution_id" {
  description = "The identifier for the distribution."
  value       = module.cloudfront.cloudfront_distribution_id
}

output "cloudfront_distribution_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution."
  value       = module.cloudfront.cloudfront_distribution_arn
}

output "cloudfront_distribution_caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
  value       = module.cloudfront.cloudfront_distribution_caller_reference
}

output "cloudfront_distribution_status" {
  description = "The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system."
  value       = module.cloudfront.cloudfront_distribution_status
}

output "cloudfront_distribution_trusted_signers" {
  description = "List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs"
  value       = module.cloudfront.cloudfront_distribution_trusted_signers
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name corresponding to the distribution."
  value       = module.cloudfront.cloudfront_distribution_domain_name
}

output "cloudfront_distribution_last_modified_time" {
  description = "The date and time the distribution was last modified."
  value       = module.cloudfront.cloudfront_distribution_last_modified_time
}

output "cloudfront_distribution_in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress."
  value       = module.cloudfront.cloudfront_distribution_in_progress_validation_batches
}

output "cloudfront_distribution_etag" {
  description = "The current version of the distribution's information."
  value       = module.cloudfront.cloudfront_distribution_etag
}

output "cloudfront_distribution_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
  value       = module.cloudfront.cloudfront_distribution_hosted_zone_id
}

################################################################################
# Origin Access Control
################################################################################

output "cloudfront_origin_access_controls" {
  description = "The origin access controls created"
  value       = module.cloudfront.cloudfront_origin_access_controls
}

################################################################################
# VPC Origin
################################################################################

output "cloudfront_vpc_origins" {
  description = "The IDS of the VPC origin created"
  value       = module.cloudfront.cloudfront_vpc_origins
}

################################################################################
# Response Headers Policy
################################################################################

output "cloudfront_response_headers_policies" {
  description = "The response headers policies created"
  value       = module.cloudfront.cloudfront_response_headers_policies
}

################################################################################
# Function(s)
################################################################################

output "cloudfront_functions" {
  description = "The CloudFront Functions created"
  value       = module.cloudfront.cloudfront_functions
}

################################################################################
# Monitoring Subscription
################################################################################

output "cloudfront_monitoring_subscription_id" {
  description = " The ID of the CloudFront monitoring subscription, which corresponds to the `distribution_id`."
  value       = module.cloudfront.cloudfront_monitoring_subscription_id
}
