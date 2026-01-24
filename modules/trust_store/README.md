# trust_store

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.28 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.28 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_trust_store.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_trust_store) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ca_cert_bucket"></a> [ca\_cert\_bucket](#input\_ca\_cert\_bucket) | S3 bucket name containing the CA certificates bundle | `string` | `null` | no |
| <a name="input_ca_cert_key"></a> [ca\_cert\_key](#input\_ca\_cert\_key) | S3 object key for the CA certificates bundle | `string` | `null` | no |
| <a name="input_ca_cert_region"></a> [ca\_cert\_region](#input\_ca\_cert\_region) | AWS region of the S3 bucket | `string` | `null` | no |
| <a name="input_ca_cert_version"></a> [ca\_cert\_version](#input\_ca\_cert\_version) | S3 object version ID for the CA certificates bundle | `string` | `null` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created (affects nearly all resources) | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the trust store. Changing this forces a new resource to be created | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value tags for the place index | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the trust store |
| <a name="output_etag"></a> [etag](#output\_etag) | ETag of the trust store |
| <a name="output_id"></a> [id](#output\_id) | The ID of the trust store |
| <a name="output_number_of_ca_certificates"></a> [number\_of\_ca\_certificates](#output\_number\_of\_ca\_certificates) | Number of CA certificates in the trust store |
<!-- END_TF_DOCS -->
