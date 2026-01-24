output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = module.cloudfront.cloudfront_distribution_id
}

output "cloudfront_distribution_domain" {
  description = "The domain name of the CloudFront distribution"
  value       = module.cloudfront.cloudfront_distribution_domain_name
}

output "trust_store_id" {
  description = "The ID of the CloudFront trust store"
  value       = module.trust_store.id
}

output "trust_store_arn" {
  description = "The ARN of the CloudFront trust store"
  value       = module.trust_store.arn
}

output "trust_store_etag" {
  description = "ETAG of the CloudFront trust store"
  value       = module.trust_store.etag
}

output "trust_store_number_of_ca_certificates" {
  description = "Number of CA certificates in the trust store"
  value       = module.trust_store.number_of_ca_certificates
}

output "ca_certificate_pem" {
  description = "The CA certificate in PEM format"
  value       = tls_self_signed_cert.ca.cert_pem
  sensitive   = true
}

output "client_certificate_pem" {
  description = "The client certificate in PEM format"
  value       = tls_locally_signed_cert.client.cert_pem
  sensitive   = true
}

output "client_private_key_pem" {
  description = "The client private key in PEM format"
  value       = tls_private_key.client.private_key_pem
  sensitive   = true
}
