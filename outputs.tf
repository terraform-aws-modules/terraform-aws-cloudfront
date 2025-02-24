output "cloudfront_distribution_id" {
  description = "The identifier for the distribution."
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.id }
}

output "cloudfront_distribution_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution."
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.arn }
}

output "cloudfront_distribution_caller_reference" {
  description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.caller_reference }
}

output "cloudfront_distribution_status" {
  description = "The current status of the distribution."
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.status }
}

output "cloudfront_distribution_trusted_signers" {
  description = "List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs"
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.trusted_signers }
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name corresponding to the distribution."
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.domain_name }
}

output "cloudfront_distribution_last_modified_time" {
  description = "The date and time the distribution was last modified."
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.last_modified_time }
}

output "cloudfront_distribution_in_progress_validation_batches" {
  description = "The number of invalidation batches currently in progress."
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.in_progress_validation_batches }
}

output "cloudfront_distribution_etag" {
  description = "The current version of the distribution's information."
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.etag }
}

output "cloudfront_distribution_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to."
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.hosted_zone_id }
}

output "cloudfront_distribution_tags" {
  description = "Tags of the distributions"
  value       = { for k, v in aws_cloudfront_distribution.this : k => v.tags_all }
}
