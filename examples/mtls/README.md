# mTLS with CloudFront Distribution

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.28 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.28 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> 4.0 |
| <a name="module_ca_certificates"></a> [ca\_certificates](#module\_ca\_certificates) | terraform-aws-modules/s3-bucket/aws | ~> 5.0 |
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | ../../ | n/a |
| <a name="module_records"></a> [records](#module\_records) | terraform-aws-modules/route53/aws//modules/records | ~> 5.0 |
| <a name="module_s3"></a> [s3](#module\_s3) | terraform-aws-modules/s3-bucket/aws | ~> 5.0 |
| <a name="module_trust_store"></a> [trust\_store](#module\_trust\_store) | ../../modules/trust_store | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_object.ca_certificates](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [random_id.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_id.example_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [tls_cert_request.client](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request) | resource |
| [tls_locally_signed_cert.client](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert) | resource |
| [tls_private_key.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.client](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | The domain name to use when deploying the CloudFront distribution | `string` | `"terraform-aws-modules.modules.tf"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca_certificate_pem"></a> [ca\_certificate\_pem](#output\_ca\_certificate\_pem) | The CA certificate in PEM format |
| <a name="output_client_certificate_pem"></a> [client\_certificate\_pem](#output\_client\_certificate\_pem) | The client certificate in PEM format |
| <a name="output_client_private_key_pem"></a> [client\_private\_key\_pem](#output\_client\_private\_key\_pem) | The client private key in PEM format |
| <a name="output_cloudfront_distribution_domain"></a> [cloudfront\_distribution\_domain](#output\_cloudfront\_distribution\_domain) | The domain name of the CloudFront distribution |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The ID of the CloudFront distribution |
| <a name="output_connection_function_arn"></a> [connection\_function\_arn](#output\_connection\_function\_arn) | ARN of the connection function |
| <a name="output_connection_function_etag"></a> [connection\_function\_etag](#output\_connection\_function\_etag) | ETag of the connection function |
| <a name="output_connection_function_id"></a> [connection\_function\_id](#output\_connection\_function\_id) | ID of the connection function |
| <a name="output_connection_function_live_stage_etag"></a> [connection\_function\_live\_stage\_etag](#output\_connection\_function\_live\_stage\_etag) | ETag of the function's LIVE stage. Will be empty if the function has not been published |
| <a name="output_connection_function_status"></a> [connection\_function\_status](#output\_connection\_function\_status) | Status of the connection function |
| <a name="output_trust_store_arn"></a> [trust\_store\_arn](#output\_trust\_store\_arn) | The ARN of the CloudFront trust store |
| <a name="output_trust_store_etag"></a> [trust\_store\_etag](#output\_trust\_store\_etag) | ETAG of the CloudFront trust store |
| <a name="output_trust_store_id"></a> [trust\_store\_id](#output\_trust\_store\_id) | The ID of the CloudFront trust store |
| <a name="output_trust_store_number_of_ca_certificates"></a> [trust\_store\_number\_of\_ca\_certificates](#output\_trust\_store\_number\_of\_ca\_certificates) | Number of CA certificates in the trust store |
<!-- END_TF_DOCS -->
