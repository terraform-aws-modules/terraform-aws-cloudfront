output "id" {
  description = "The ID of the trust store"
  value       = try(aws_cloudfront_trust_store.this[0].id, null)
}

output "arn" {
  description = "The ARN of the trust store"
  value       = try(aws_cloudfront_trust_store.this[0].arn, null)
}

output "etag" {
  description = "ETag of the trust store"
  value       = try(aws_cloudfront_trust_store.this[0].etag, null)
}

output "number_of_ca_certificates" {
  description = "Number of CA certificates in the trust store"
  value       = try(aws_cloudfront_trust_store.this[0].number_of_ca_certificates, null)
}
